///|
struct PaintTransform {
  matrix : @fixed.Matrix
  dx : Int64
  dy : Int64
} derive(Show)

///|
fn PaintTransform::identity() -> PaintTransform {
  { matrix: @fixed.Matrix::identity(), dx: 0L, dy: 0L }
}

///|
fn copy_matrix(matrix : @fixed.Matrix) -> @fixed.Matrix {
  @fixed.Matrix::new(matrix.xx(), matrix.xy(), matrix.yx(), matrix.yy())
}

///|
fn compose_paint_transform(
  current : PaintTransform,
  node_matrix : @fixed.Matrix,
  node_dx : Int64,
  node_dy : Int64,
) -> PaintTransform {
  let matrix = copy_matrix(node_matrix)
  matrix.multiply(current.matrix)
  let (tdx, tdy) = current.matrix.transform(node_dx, node_dy)
  { matrix, dx: current.dx + tdx, dy: current.dy + tdy }
}

///|
fn scale_colr_translation_component(
  scale : @fixed.Fixed,
  value : Int64,
) -> Int64 {
  if value == 0L {
    return 0L
  }
  let num = value * scale.val()
  let den = 0x1_0000_0000L
  if num >= 0L {
    (num + den / 2L) / den
  } else {
    -((-num + den / 2L) / den)
  }
}

///|
fn scale_colr_offset(
  x_scale : @fixed.Fixed,
  y_scale : @fixed.Fixed,
  dx : Int64,
  dy : Int64,
) -> (Int64, Int64) {
  (
    scale_colr_translation_component(x_scale, dx),
    scale_colr_translation_component(y_scale, dy),
  )
}

///|
fn alpha_f2dot14_to_8(raw_alpha : Int) -> Int {
  let clamped = if raw_alpha <= 0 {
    0
  } else if raw_alpha >= 0x4000 {
    0x4000
  } else {
    raw_alpha
  }
  (clamped * 255 + 0x2000) / 0x4000
}

///|
fn resolve_palette_color(
  palette : Array[@types.Color],
  foreground_color : @types.Color,
  palette_index : UInt,
) -> @types.Color raise @error.FTError {
  if palette_index == 0xFFFFU {
    return foreground_color
  }
  let idx = palette_index.reinterpret_as_int()
  if idx < 0 || idx >= palette.length() {
    raise @error.FTError::InvalidTable
  }
  palette[idx]
}

///|
fn rotation_matrix(angle : @fixed.Fixed) -> @fixed.Matrix {
  let raw_angle = angle.val()
  let (cosine, sine) = @fixed.vector_rotate(0x10000L, 0L, raw_angle)
  @fixed.Matrix::new(
    @fixed.Fixed::from_raw(cosine),
    @fixed.Fixed::from_raw(-sine),
    @fixed.Fixed::from_raw(sine),
    @fixed.Fixed::from_raw(cosine),
  )
}

///|
fn skew_matrix(x_angle : @fixed.Fixed, y_angle : @fixed.Fixed) -> @fixed.Matrix {
  @fixed.Matrix::new(
    @fixed.Fixed::one(),
    @fixed.tan(x_angle.val()),
    @fixed.tan(y_angle.val()),
    @fixed.Fixed::one(),
  )
}

///|
fn transform_about(
  base : @fixed.Matrix,
  cx : Int64,
  cy : Int64,
) -> (Int64, Int64) {
  let (tx, ty) = base.transform(cx, cy)
  (cx - tx, cy - ty)
}

///|
fn apply_transform_to_outline(
  outline : @types.Outline,
  transform : PaintTransform,
) -> Unit {
  @base.outline_transform(outline, transform.matrix)
  if transform.dx != 0L || transform.dy != 0L {
    @base.outline_translate(outline, transform.dx, transform.dy)
  }
}

///|
fn render_transformed_mask(
  outline : @types.Outline,
  transform : PaintTransform,
) -> @color.GrayMaskSurface raise @error.FTError {
  if outline.n_points() == 0 || outline.n_contours() == 0 {
    return @color.GrayMaskSurface::empty()
  }
  apply_transform_to_outline(outline, transform)
  let (bitmap, left, top) = @smooth.render_outline_normal(outline)
  @color.gray_mask_from_bitmap(bitmap, left, top)
}

///|
fn apply_clips(
  surface : @color.BgraSurface,
  clips : Array[@color.GrayMaskSurface],
) -> Unit {
  for clip in clips {
    surface.apply_mask(clip)
  }
}

///|
fn render_v0_layer_surface(
  layer : @color.ColrV0Layer,
  clips : Array[@color.GrayMaskSurface],
  transform : PaintTransform,
  load_flags : Int,
  palette : Array[@types.Color],
  foreground_color : @types.Color,
  load_scaled_outline : (UInt, Int) -> @types.Outline raise @error.FTError,
) -> @color.BgraSurface raise @error.FTError {
  let color = resolve_palette_color(
    palette,
    foreground_color,
    layer.palette_index(),
  )
  let outline = load_scaled_outline(layer.glyph_id(), load_flags)
  let mask = render_transformed_mask(outline, transform)
  let surface = @color.surface_from_mask(mask, color)
  apply_clips(surface, clips)
  surface
}

///|
fn render_colr_glyph_surface(
  colr : @color.ColrTable,
  glyph_id : UInt,
  clips : Array[@color.GrayMaskSurface],
  normalized_coords : Array[Int],
  transform : PaintTransform,
  load_flags : Int,
  palette : Array[@types.Color],
  foreground_color : @types.Color,
  x_scale : @fixed.Fixed,
  y_scale : @fixed.Fixed,
  load_scaled_outline : (UInt, Int) -> @types.Outline raise @error.FTError,
  depth : Int,
) -> @color.BgraSurface raise @error.FTError {
  if depth > 16 {
    raise @error.FTError::InvalidTable
  }
  let local_clips : Array[@color.GrayMaskSurface] = []
  for clip in clips {
    local_clips.push(clip)
  }
  match colr.clip_box(glyph_id, normalized_coords~) {
    Some(clip_box) => {
      let clip_mask = render_clip_box_mask(
        clip_box, transform, x_scale, y_scale,
      )
      if !clip_mask.is_empty() {
        local_clips.push(clip_mask)
      }
    }
    None => ()
  }
  match colr.v1_root_paint_offset(glyph_id) {
    Some(root) =>
      render_colr_paint_surface(
        colr,
        root,
        local_clips,
        normalized_coords,
        transform,
        load_flags,
        palette,
        foreground_color,
        x_scale,
        y_scale,
        load_scaled_outline,
        depth + 1,
      )
    None => {
      let layers = colr.v0_layers(glyph_id)
      let surface = @color.BgraSurface::new()
      for layer in layers {
        surface.blend_surface(
          render_v0_layer_surface(
            layer, local_clips, transform, load_flags, palette, foreground_color,
            load_scaled_outline,
          ),
        )
      }
      surface
    }
  }
}

///|
fn render_colr_paint_surface(
  colr : @color.ColrTable,
  paint_offset : Int,
  clips : Array[@color.GrayMaskSurface],
  normalized_coords : Array[Int],
  transform : PaintTransform,
  load_flags : Int,
  palette : Array[@types.Color],
  foreground_color : @types.Color,
  x_scale : @fixed.Fixed,
  y_scale : @fixed.Fixed,
  load_scaled_outline : (UInt, Int) -> @types.Outline raise @error.FTError,
  depth : Int,
) -> @color.BgraSurface raise @error.FTError {
  if depth > 24 {
    raise @error.FTError::InvalidTable
  }
  match colr.read_paint(paint_offset, normalized_coords~) {
    ColrLayers(num_layers, first_layer_index) => {
      let surface = @color.BgraSurface::new()
      for
        child_offset in colr.v1_layer_paint_offsets(
          first_layer_index, num_layers,
        ) {
        surface.blend_surface(
          render_colr_paint_surface(
            colr,
            child_offset,
            clips,
            normalized_coords,
            transform,
            load_flags,
            palette,
            foreground_color,
            x_scale,
            y_scale,
            load_scaled_outline,
            depth + 1,
          ),
        )
      }
      surface
    }
    Solid(palette_index, alpha) =>
      if clips.is_empty() {
        @color.BgraSurface::new()
      } else {
        let alpha_scale = alpha_f2dot14_to_8(alpha)
        let base_color = resolve_palette_color(
          palette, foreground_color, palette_index,
        )
        let surface = @color.surface_from_mask(
          clips[clips.length() - 1],
          base_color,
          alpha_scale~,
        )
        apply_parent_clips(surface, clips)
        surface
      }
    LinearGradient(color_line, p0x, p0y, p1x, p1y, p2x, p2y) =>
      if clips.is_empty() {
        @color.BgraSurface::new()
      } else {
        let surface = render_linear_gradient_surface(
          clips[clips.length() - 1],
          color_line,
          palette,
          foreground_color,
          transform,
          p0x,
          p0y,
          p1x,
          p1y,
          p2x,
          p2y,
          x_scale,
          y_scale,
        )
        apply_parent_clips(surface, clips)
        surface
      }
    RadialGradient(color_line, c0x, c0y, r0, c1x, c1y, r1) =>
      if clips.is_empty() {
        @color.BgraSurface::new()
      } else {
        let surface = render_radial_gradient_surface(
          clips[clips.length() - 1],
          color_line,
          palette,
          foreground_color,
          transform,
          c0x,
          c0y,
          r0,
          c1x,
          c1y,
          r1,
          x_scale,
          y_scale,
        )
        apply_parent_clips(surface, clips)
        surface
      }
    SweepGradient(color_line, center_x, center_y, start_angle, end_angle) =>
      if clips.is_empty() {
        @color.BgraSurface::new()
      } else {
        let surface = render_sweep_gradient_surface(
          clips[clips.length() - 1],
          color_line,
          palette,
          foreground_color,
          transform,
          center_x,
          center_y,
          start_angle,
          end_angle,
          x_scale,
          y_scale,
        )
        apply_parent_clips(surface, clips)
        surface
      }
    Glyph(child_paint_offset, glyph_id) => {
      let outline = load_scaled_outline(glyph_id, load_flags)
      let glyph_clip = render_transformed_mask(outline, transform)
      let next_clips : Array[@color.GrayMaskSurface] = []
      for clip in clips {
        next_clips.push(clip)
      }
      next_clips.push(glyph_clip)
      render_colr_paint_surface(
        colr,
        child_paint_offset,
        next_clips,
        normalized_coords,
        transform,
        load_flags,
        palette,
        foreground_color,
        x_scale,
        y_scale,
        load_scaled_outline,
        depth + 1,
      )
    }
    ColrGlyph(glyph_id) =>
      render_colr_glyph_surface(
        colr,
        glyph_id,
        clips,
        normalized_coords,
        transform,
        load_flags,
        palette,
        foreground_color,
        x_scale,
        y_scale,
        load_scaled_outline,
        depth + 1,
      )
    Transform(child_offset, matrix, dx, dy) => {
      let (sdx, sdy) = scale_colr_offset(x_scale, y_scale, dx, dy)
      render_colr_paint_surface(
        colr,
        child_offset,
        clips,
        normalized_coords,
        compose_paint_transform(transform, matrix, sdx, sdy),
        load_flags,
        palette,
        foreground_color,
        x_scale,
        y_scale,
        load_scaled_outline,
        depth + 1,
      )
    }
    Translate(child_offset, dx, dy) => {
      let (sdx, sdy) = scale_colr_offset(x_scale, y_scale, dx, dy)
      render_colr_paint_surface(
        colr,
        child_offset,
        clips,
        normalized_coords,
        compose_paint_transform(transform, @fixed.Matrix::identity(), sdx, sdy),
        load_flags,
        palette,
        foreground_color,
        x_scale,
        y_scale,
        load_scaled_outline,
        depth + 1,
      )
    }
    Scale(child_offset, sx, sy, cx, cy) => {
      let (scx, scy) = scale_colr_offset(x_scale, y_scale, cx, cy)
      let matrix = @fixed.Matrix::new(
        sx,
        @fixed.Fixed::zero(),
        @fixed.Fixed::zero(),
        sy,
      )
      let (dx, dy) = transform_about(matrix, scx, scy)
      render_colr_paint_surface(
        colr,
        child_offset,
        clips,
        normalized_coords,
        compose_paint_transform(transform, matrix, dx, dy),
        load_flags,
        palette,
        foreground_color,
        x_scale,
        y_scale,
        load_scaled_outline,
        depth + 1,
      )
    }
    Rotate(child_offset, angle, cx, cy) => {
      let (rcx, rcy) = scale_colr_offset(x_scale, y_scale, cx, cy)
      let matrix = rotation_matrix(angle)
      let (dx, dy) = transform_about(matrix, rcx, rcy)
      render_colr_paint_surface(
        colr,
        child_offset,
        clips,
        normalized_coords,
        compose_paint_transform(transform, matrix, dx, dy),
        load_flags,
        palette,
        foreground_color,
        x_scale,
        y_scale,
        load_scaled_outline,
        depth + 1,
      )
    }
    Skew(child_offset, x_angle, y_angle, cx, cy) => {
      let (scx, scy) = scale_colr_offset(x_scale, y_scale, cx, cy)
      let matrix = skew_matrix(x_angle, y_angle)
      let (dx, dy) = transform_about(matrix, scx, scy)
      render_colr_paint_surface(
        colr,
        child_offset,
        clips,
        normalized_coords,
        compose_paint_transform(transform, matrix, dx, dy),
        load_flags,
        palette,
        foreground_color,
        x_scale,
        y_scale,
        load_scaled_outline,
        depth + 1,
      )
    }
    Composite(source_offset, composite_mode, backdrop_offset) => {
      let backdrop = render_colr_paint_surface(
        colr,
        backdrop_offset,
        clips,
        normalized_coords,
        transform,
        load_flags,
        palette,
        foreground_color,
        x_scale,
        y_scale,
        load_scaled_outline,
        depth + 1,
      )
      let source = render_colr_paint_surface(
        colr,
        source_offset,
        clips,
        normalized_coords,
        transform,
        load_flags,
        palette,
        foreground_color,
        x_scale,
        y_scale,
        load_scaled_outline,
        depth + 1,
      )
      let out = backdrop
      out.blend_surface(source, composite_mode~)
      out
    }
    Unsupported(_) => raise @error.FTError::UnimplementedFeature
  }
}

///|
fn render_colr_bitmap_glyph(
  colr : @color.ColrTable,
  glyph_index : UInt,
  load_flags : Int,
  palette : Array[@types.Color],
  foreground_color : @types.Color,
  normalized_coords : Array[Int],
  x_scale : @fixed.Fixed,
  y_scale : @fixed.Fixed,
  load_scaled_outline : (UInt, Int) -> @types.Outline raise @error.FTError,
) -> (@types.Bitmap, Int, Int)? raise @error.FTError {
  let surface = render_colr_glyph_surface(
    colr,
    glyph_index,
    [],
    normalized_coords,
    PaintTransform::identity(),
    load_flags,
    palette,
    foreground_color,
    x_scale,
    y_scale,
    load_scaled_outline,
    0,
  )
  if surface.is_empty() {
    None
  } else {
    Some(surface.to_bitmap())
  }
}
