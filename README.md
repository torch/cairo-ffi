### Drawing Context

<a name="Context.status"></a>
#### Context.status()

Checks whether an error has previously occurred for this context.

_Returns_: the current status of this context, see [`Status`](enums.md#Status)

<a name="Context.save"></a>
#### Context.save()

Makes a copy of the current state of `cr` and saves it
on an internal stack of saved states for `cr`. When
[`Context.restore()`](#Context.restore) is called, `cr` will be restored to
the saved state. Multiple calls to [`Context.save()`](#Context.save) and
[`Context.restore()`](#Context.restore) can be nested; each call to [`Context.restore()`](#Context.restore)
restores the state from the matching paired [`Context.save()`](#Context.save).

It isn't necessary to clear all saved states before
a [`Context`](#Context) is freed. If the reference count of a [`Context`](#Context)
drops to zero in response to a call to [`Context.destroy()`](#Context.destroy),
any saved states will be freed along with the [`Context`](#Context).

<a name="Context.restore"></a>
#### Context.restore()

Restores `cr` to the state saved by a preceding call to
[`Context.save()`](#Context.save) and removes that state from the stack of
saved states.

<a name="Context.getTarget"></a>
#### Context.getTarget()

Gets the target surface for the cairo context as passed to
[`Context.new()`](#Context.new).

This function will always return a valid pointer, but the result
can be a "nil" surface if `cr` is already in an error state,
(ie. [`Context.status()`](#Context.status) `!=` [`"success"`](enums.md#Status)).
A nil surface is indicated by [`Surface.status()`](surface.md#Surface.status)
`!=` [`"success"`](enums.md#Status).

_Return value_: the target surface. This object is owned by cairo. To
keep a reference to it, you must call [`Surface.reference()`](surface.md#Surface.reference).

<a name="Context.pushGroup"></a>
#### Context.pushGroup()

Temporarily redirects drawing to an intermediate surface known as a
group. The redirection lasts until the group is completed by a call
to [`Context.popGroup()`](#Context.popGroup) or [`Context.popGroupToSource()`](#Context.popGroupToSource). These calls
provide the result of any drawing to the group as a pattern,
(either as an explicit object, or set as the source pattern).

This group functionality can be convenient for performing
intermediate compositing. One common use of a group is to render
objects as opaque within the group, (so that they occlude each
other), and then blend the result with translucence onto the
destination.

Groups can be nested arbitrarily deep by making balanced calls to
[`Context.pushGroup()/cairoPopGroup()`](#Context.pushGroup()/cairoPopGroup). Each call pushes/pops the new
target group onto/from a stack.

The [`Context.pushGroup()`](#Context.pushGroup) function calls [`Context.save()`](#Context.save) so that any
changes to the graphics state will not be visible outside the
group, (the pop_group functions call [`Context.restore()`](#Context.restore)).

By default the intermediate group will have a content type of
[`"color-alpha"`](enums.md#Content). Other content types can be chosen for
the group by using [`Context.pushGroupWithContent()`](#Context.pushGroupWithContent) instead.

As an example, here is how one might fill and stroke a path with
translucence, but without any portion of the fill being visible
under the stroke:

```lua
cairo_push_group (cr);
cairo_set_source (cr, fill_pattern);
cairo_fill_preserve (cr);
cairo_set_source (cr, stroke_pattern);
cairo_stroke (cr);
cairo_pop_group_to_source (cr);
cairo_paint_with_alpha (cr, alpha);
```

<a name="Context.pushGroupWithContent"></a>
#### Context.pushGroupWithContent()

Temporarily redirects drawing to an intermediate surface known as a
group. The redirection lasts until the group is completed by a call
to [`Context.popGroup()`](#Context.popGroup) or [`Context.popGroupToSource()`](#Context.popGroupToSource). These calls
provide the result of any drawing to the group as a pattern,
(either as an explicit object, or set as the source pattern).

The group will have a content type of `content`. The ability to
control this content type is the only distinction between this
function and [`Context.pushGroup()`](#Context.pushGroup) which you should see for a more
detailed description of group rendering.

<a name="Context.popGroup"></a>
#### Context.popGroup()

Terminates the redirection begun by a call to [`Context.pushGroup()`](#Context.pushGroup) or
[`Context.pushGroupWithContent()`](#Context.pushGroupWithContent) and returns a new pattern
containing the results of all drawing operations performed to the
group.

The [`Context.popGroup()`](#Context.popGroup) function calls [`Context.restore()`](#Context.restore), (balancing a
call to [`Context.save()`](#Context.save) by the push_group function), so that any
changes to the graphics state will not be visible outside the
group.

_Return value_: a newly created (surface) pattern containing the
results of all drawing operations performed to the group. The
caller owns the returned object and should call
[`Pattern.destroy()`](pattern.md#Pattern.destroy) when finished with it.

<a name="Context.popGroupToSource"></a>
#### Context.popGroupToSource()

Terminates the redirection begun by a call to [`Context.pushGroup()`](#Context.pushGroup) or
[`Context.pushGroupWithContent()`](#Context.pushGroupWithContent) and installs the resulting pattern
as the source pattern in the given cairo context.

The behavior of this function is equivalent to the sequence of
operations:

```lua
cairo_pattern_t *group = cairo_pop_group (cr);
cairo_set_source (cr, group);
cairo_pattern_destroy (group);
```

but is more convenient as their is no need for a variable to store
the short-lived pointer to the pattern.

The [`Context.popGroup()`](#Context.popGroup) function calls [`Context.restore()`](#Context.restore), (balancing a
call to [`Context.save()`](#Context.save) by the push_group function), so that any
changes to the graphics state will not be visible outside the
group.

<a name="Context.getGroupTarget"></a>
#### Context.getGroupTarget()

Gets the current destination surface for the context. This is either
the original target surface as passed to [`Context.new()`](#Context.new) or the target
surface for the current group as started by the most recent call to
[`Context.pushGroup()`](#Context.pushGroup) or [`Context.pushGroupWithContent()`](#Context.pushGroupWithContent).

This function will always return a valid pointer, but the result
can be a "nil" surface if `cr` is already in an error state,
(ie. [`Context.status()`](#Context.status) `!=` [`"success"`](enums.md#Status)).
A nil surface is indicated by [`Surface.status()`](surface.md#Surface.status)
`!=` [`"success"`](enums.md#Status).

_Return value_: the target surface. This object is owned by cairo. To
keep a reference to it, you must call [`Surface.reference()`](surface.md#Surface.reference).

<a name="Context.setSource"></a>
#### Context.setSource()

Sets the source pattern within `cr` to `source`. This pattern
will then be used for any subsequent drawing operation until a new
source pattern is set.

Note: The pattern's transformation matrix will be locked to the
user space in effect at the time of [`Context.setSource()`](#Context.setSource). This means
that further modifications of the current transformation matrix
will not affect the source pattern. See [`Pattern.setMatrix()`](pattern.md#Pattern.setMatrix).

The default source pattern is a solid pattern that is opaque black,
(that is, it is equivalent to cairo_set_source_rgb(cr, 0.0, 0.0,
0.0)).

<a name="Context.setSourceSurface"></a>
#### Context.setSourceSurface()

This is a convenience function for creating a pattern from `surface`
and setting it as the source in `cr` with [`Context.setSource()`](#Context.setSource).

The `x` and `y` parameters give the user-space coordinate at which
the surface origin should appear. (The surface origin is its
upper-left corner before any transformation has been applied.) The
`x` and `y` parameters are negated and then set as translation values
in the pattern matrix.

Other than the initial translation pattern matrix, as described
above, all other pattern attributes, (such as its extend mode), are
set to the default values as in [`Pattern.createForSurface()`](pattern.md#Pattern.createForSurface).
The resulting pattern can be queried with [`Context.getSource()`](#Context.getSource) so
that these attributes can be modified if desired, (eg. to create a
repeating pattern with [`Pattern.setExtend()`](pattern.md#Pattern.setExtend)).

<a name="Context.getSource"></a>
#### Context.getSource()

Gets the current source pattern for `cr`.

_Return value_: the current source pattern. This object is owned by
cairo. To keep a reference to it, you must call
[`Pattern.reference()`](pattern.md#Pattern.reference).

<a name="Context.setAntialias"></a>
#### Context.setAntialias()

Set the antialiasing mode of the rasterizer used for drawing shapes.
This value is a hint, and a particular backend may or may not support
a particular value.  At the current time, no backend supports
[`"subpixel"`](enums.md#Antialias) when drawing shapes.

Note that this option does not affect text rendering, instead see
[`FontOptions.setAntialias()`](fontoptions.md#FontOptions.setAntialias).

<a name="Context.getAntialias"></a>
#### Context.getAntialias()

Gets the current shape antialiasing mode, as set by
[`Context.setAntialias()`](#Context.setAntialias).

_Return value_: the current shape antialiasing mode.

<a name="Context.setDash"></a>
#### Context.setDash()

Sets the dash pattern to be used by [`Context.stroke()`](#Context.stroke). A dash pattern
is specified by `dashes`, an array of positive values. Each value
provides the length of alternate "on" and "off" portions of the
stroke. The `offset` specifies an offset into the pattern at which
the stroke begins.

Each "on" segment will have caps applied as if the segment were a
separate sub-path. In particular, it is valid to use an "on" length
of 0.0 with [`"round"`](enums.md#LineCap) or [`"square"`](enums.md#LineCap) in order
to distributed dots or squares along a path.

Note: The length values are in user-space units as evaluated at the
time of stroking. This is not necessarily the same as the user
space at the time of [`Context.setDash()`](#Context.setDash).

If `num_dashes` is 0 dashing is disabled.

If `num_dashes` is 1 a symmetric pattern is assumed with alternating
on and off portions of the size specified by the single value in
`dashes`.

If any value in `dashes` is negative, or if all values are 0, then
`cr` will be put into an error state with a status of
[`"invalid-dash"`](enums.md#Status).

<a name="Context.getDashCount"></a>
#### Context.getDashCount()

This function returns the length of the dash array in `cr` (0 if dashing
is not currently in effect).

See also [`Context.setDash()`](#Context.setDash) and [`Context.getDash()`](#Context.getDash).

_Return value_: the length of the dash array, or 0 if no dash array set.

<a name="Context.getDash"></a>
#### Context.getDash()

Gets the current dash array.  If not `nil`, `dashes` should be big
enough to hold at least the number of values returned by
[`Context.getDashCount()`](#Context.getDashCount).

<a name="Context.setFillRule"></a>
#### Context.setFillRule()

Set the current fill rule within the cairo context. The fill rule
is used to determine which regions are inside or outside a complex
(potentially self-intersecting) path. The current fill rule affects
both [`Context.fill()`](#Context.fill) and [`Context.clip()`](#Context.clip). See [`FillRule`](enums.md#FillRule) for details
on the semantics of each available fill rule.

The default fill rule is [`"winding"`](enums.md#FillRule).

<a name="Context.getFillRule"></a>
#### Context.getFillRule()

Gets the current fill rule, as set by [`Context.setFillRule()`](#Context.setFillRule).

_Return value_: the current fill rule.

<a name="Context.setLineCap"></a>
#### Context.setLineCap()

Sets the current line cap style within the cairo context. See
[`LineCap`](enums.md#LineCap) for details about how the available line cap
styles are drawn.

As with the other stroke parameters, the current line cap style is
examined by [`Context.stroke()`](#Context.stroke), [`Context.strokeExtents()`](#Context.strokeExtents), and
[`Context.strokeToPath()`](#Context.strokeToPath), but does not have any effect during path
construction.

The default line cap style is [`"butt"`](enums.md#LineCap).

<a name="Context.getLineCap"></a>
#### Context.getLineCap()

Gets the current line cap style, as set by [`Context.setLineCap()`](#Context.setLineCap).

_Return value_: the current line cap style.

<a name="Context.setLineJoin"></a>
#### Context.setLineJoin()

Sets the current line join style within the cairo context. See
[`LineJoin`](enums.md#LineJoin) for details about how the available line join
styles are drawn.

As with the other stroke parameters, the current line join style is
examined by [`Context.stroke()`](#Context.stroke), [`Context.strokeExtents()`](#Context.strokeExtents), and
[`Context.strokeToPath()`](#Context.strokeToPath), but does not have any effect during path
construction.

The default line join style is [`"miter"`](enums.md#LineJoin).

<a name="Context.getLineJoin"></a>
#### Context.getLineJoin()

Gets the current line join style, as set by [`Context.setLineJoin()`](#Context.setLineJoin).

_Return value_: the current line join style.

<a name="Context.setLineWidth"></a>
#### Context.setLineWidth()

Sets the current line width within the cairo context. The line
width value specifies the diameter of a pen that is circular in
user space, (though device-space pen may be an ellipse in general
due to scaling/shear/rotation of the CTM).

Note: When the description above refers to user space and CTM it
refers to the user space and CTM in effect at the time of the
stroking operation, not the user space and CTM in effect at the
time of the call to [`Context.setLineWidth()`](#Context.setLineWidth). The simplest usage
makes both of these spaces identical. That is, if there is no
change to the CTM between a call to [`Context.setLineWidth()`](#Context.setLineWidth) and the
stroking operation, then one can just pass user-space values to
[`Context.setLineWidth()`](#Context.setLineWidth) and ignore this note.

As with the other stroke parameters, the current line width is
examined by [`Context.stroke()`](#Context.stroke), [`Context.strokeExtents()`](#Context.strokeExtents), and
[`Context.strokeToPath()`](#Context.strokeToPath), but does not have any effect during path
construction.

The default line width value is 2.0.

<a name="Context.getLineWidth"></a>
#### Context.getLineWidth()

This function returns the current line width value exactly as set by
[`Context.setLineWidth()`](#Context.setLineWidth). Note that the value is unchanged even if
the CTM has changed between the calls to [`Context.setLineWidth()`](#Context.setLineWidth) and
[`Context.getLineWidth()`](#Context.getLineWidth).

_Return value_: the current line width.

<a name="Context.setMiterLimit"></a>
#### Context.setMiterLimit()

Sets the current miter limit within the cairo context.

If the current line join style is set to [`"miter"`](enums.md#LineJoin)
(see [`Context.setLineJoin()`](#Context.setLineJoin)), the miter limit is used to determine
whether the lines should be joined with a bevel instead of a miter.
Cairo divides the length of the miter by the line width.
If the result is greater than the miter limit, the style is
converted to a bevel.

As with the other stroke parameters, the current line miter limit is
examined by [`Context.stroke()`](#Context.stroke), [`Context.strokeExtents()`](#Context.strokeExtents), and
[`Context.strokeToPath()`](#Context.strokeToPath), but does not have any effect during path
construction.

The default miter limit value is 10.0, which will convert joins
with interior angles less than 11 degrees to bevels instead of
miters. For reference, a miter limit of 2.0 makes the miter cutoff
at 60 degrees, and a miter limit of 1.414 makes the cutoff at 90
degrees.

A miter limit for a desired angle can be computed as: miter limit =
1/sin(angle/2)

<a name="Context.getMiterLimit"></a>
#### Context.getMiterLimit()

Gets the current miter limit, as set by [`Context.setMiterLimit()`](#Context.setMiterLimit).

_Return value_: the current miter limit.

<a name="Context.setOperator"></a>
#### Context.setOperator()

Sets the compositing operator to be used for all drawing
operations. See [`Operator`](enums.md#Operator) for details on the semantics of
each available compositing operator.

The default operator is [`"over"`](enums.md#Operator).

<a name="Context.getOperator"></a>
#### Context.getOperator()

Gets the current compositing operator for a cairo context.

_Return value_: the current compositing operator.

<a name="Context.setTolerance"></a>
#### Context.setTolerance()

Sets the tolerance used when converting paths into trapezoids.
Curved segments of the path will be subdivided until the maximum
deviation between the original path and the polygonal approximation
is less than `tolerance`. The default value is 0.1. A larger
value will give better performance, a smaller value, better
appearance. (Reducing the value from the default value of 0.1
is unlikely to improve appearance significantly.)  The accuracy of paths
within Cairo is limited by the precision of its internal arithmetic, and
the prescribed `tolerance` is restricted to the smallest
representable internal value.

<a name="Context.getTolerance"></a>
#### Context.getTolerance()

Gets the current tolerance value, as set by [`Context.setTolerance()`](#Context.setTolerance).

_Return value_: the current tolerance value.

<a name="Context.clip"></a>
#### Context.clip()

Establishes a new clip region by intersecting the current clip
region with the current path as it would be filled by [`Context.fill()`](#Context.fill)
and according to the current fill rule (see [`Context.setFillRule()`](#Context.setFillRule)).

After [`Context.clip()`](#Context.clip), the current path will be cleared from the cairo
context.

The current clip region affects all drawing operations by
effectively masking out any changes to the surface that are outside
the current clip region.

Calling [`Context.clip()`](#Context.clip) can only make the clip region smaller, never
larger. But the current clip is part of the graphics state, so a
temporary restriction of the clip region can be achieved by
calling [`Context.clip()`](#Context.clip) within a [`Context.save()/cairoRestore()`](#Context.save()/cairoRestore)
pair. The only other means of increasing the size of the clip
region is [`Context.resetClip()`](#Context.resetClip).

<a name="Context.clipPreserve"></a>
#### Context.clipPreserve()

Establishes a new clip region by intersecting the current clip
region with the current path as it would be filled by [`Context.fill()`](#Context.fill)
and according to the current fill rule (see [`Context.setFillRule()`](#Context.setFillRule)).

Unlike [`Context.clip()`](#Context.clip), [`Context.clipPreserve()`](#Context.clipPreserve) preserves the path within
the cairo context.

The current clip region affects all drawing operations by
effectively masking out any changes to the surface that are outside
the current clip region.

Calling [`Context.clipPreserve()`](#Context.clipPreserve) can only make the clip region smaller, never
larger. But the current clip is part of the graphics state, so a
temporary restriction of the clip region can be achieved by
calling [`Context.clipPreserve()`](#Context.clipPreserve) within a [`Context.save()/cairoRestore()`](#Context.save()/cairoRestore)
pair. The only other means of increasing the size of the clip
region is [`Context.resetClip()`](#Context.resetClip).

<a name="Context.clipExtents"></a>
#### Context.clipExtents()

Computes a bounding box in user coordinates covering the area inside the
current clip.

<a name="Context.inClip"></a>
#### Context.inClip()

Tests whether the given point is inside the area that would be
visible through the current clip, i.e. the area that would be filled by
a [`Context.paint()`](#Context.paint) operation.

See [`Context.clip()`](#Context.clip), and [`Context.clipPreserve()`](#Context.clipPreserve).

_Return value_: A non-zero value if the point is inside, or zero if
outside.

<a name="Context.resetClip"></a>
#### Context.resetClip()

Reset the current clip region to its original, unrestricted
state. That is, set the clip region to an infinitely large shape
containing the target surface. Equivalently, if infinity is too
hard to grasp, one can imagine the clip region being reset to the
exact bounds of the target surface.

Note that code meant to be reusable should not call
[`Context.resetClip()`](#Context.resetClip) as it will cause results unexpected by
higher-level code which calls [`Context.clip()`](#Context.clip). Consider using
[`Context.save()`](#Context.save) and [`Context.restore()`](#Context.restore) around [`Context.clip()`](#Context.clip) as a more
robust means of temporarily restricting the clip region.

<a name="Context.copyClipRectangleList"></a>
#### Context.copyClipRectangleList()

Gets the current clip region as a list of rectangles in user coordinates.
Never returns `nil`.

The status in the list may be [`"clip-not-representable"`](enums.md#Status) to
indicate that the clip region cannot be represented as a list of
user-space rectangles. The status may have other values to indicate
other errors.

_Returns_: the current clip region as a list of rectangles in user coordinates,
which should be destroyed using [`Context.rectangleListDestroy()`](#Context.rectangleListDestroy).

<a name="Context.fill"></a>
#### Context.fill()

A drawing operator that fills the current path according to the
current fill rule, (each sub-path is implicitly closed before being
filled). After [`Context.fill()`](#Context.fill), the current path will be cleared from
the cairo context. See [`Context.setFillRule()`](#Context.setFillRule) and
[`Context.fillPreserve()`](#Context.fillPreserve).

<a name="Context.fillPreserve"></a>
#### Context.fillPreserve()

A drawing operator that fills the current path according to the
current fill rule, (each sub-path is implicitly closed before being
filled). Unlike [`Context.fill()`](#Context.fill), [`Context.fillPreserve()`](#Context.fillPreserve) preserves the
path within the cairo context.

See [`Context.setFillRule()`](#Context.setFillRule) and [`Context.fill()`](#Context.fill).

<a name="Context.fillExtents"></a>
#### Context.fillExtents()

Computes a bounding box in user coordinates covering the area that
would be affected, (the "inked" area), by a [`Context.fill()`](#Context.fill) operation
given the current path and fill parameters. If the current path is
empty, returns an empty rectangle ((0,0), (0,0)). Surface
dimensions and clipping are not taken into account.

Contrast with [`Path.extents()`](path.md#Path.extents), which is similar, but returns
non-zero extents for some paths with no inked area, (such as a
simple line segment).

Note that [`Context.fillExtents()`](#Context.fillExtents) must necessarily do more work to
compute the precise inked areas in light of the fill rule, so
[`Path.extents()`](path.md#Path.extents) may be more desirable for sake of performance
if the non-inked path extents are desired.

See [`Context.fill()`](#Context.fill), [`Context.setFillRule()`](#Context.setFillRule) and [`Context.fillPreserve()`](#Context.fillPreserve).

<a name="Context.inFill"></a>
#### Context.inFill()

Tests whether the given point is inside the area that would be
affected by a [`Context.fill()`](#Context.fill) operation given the current path and
filling parameters. Surface dimensions and clipping are not taken
into account.

See [`Context.fill()`](#Context.fill), [`Context.setFillRule()`](#Context.setFillRule) and [`Context.fillPreserve()`](#Context.fillPreserve).

_Return value_: A non-zero value if the point is inside, or zero if
outside.

<a name="Context.mask"></a>
#### Context.mask()

A drawing operator that paints the current source
using the alpha channel of `pattern` as a mask. (Opaque
areas of `pattern` are painted with the source, transparent
areas are not painted.)

<a name="Context.maskSurface"></a>
#### Context.maskSurface()

A drawing operator that paints the current source
using the alpha channel of `surface` as a mask. (Opaque
areas of `surface` are painted with the source, transparent
areas are not painted.)

<a name="Context.paint"></a>
#### Context.paint()

A drawing operator that paints the current source everywhere within
the current clip region.

<a name="Context.paintWithAlpha"></a>
#### Context.paintWithAlpha()

A drawing operator that paints the current source everywhere within
the current clip region using a mask of constant alpha value
`alpha`. The effect is similar to [`Context.paint()`](#Context.paint), but the drawing
is faded out using the alpha value.

<a name="Context.stroke"></a>
#### Context.stroke()

A drawing operator that strokes the current path according to the
current line width, line join, line cap, and dash settings. After
[`Context.stroke()`](#Context.stroke), the current path will be cleared from the cairo
context. See [`Context.setLineWidth()`](#Context.setLineWidth), [`Context.setLineJoin()`](#Context.setLineJoin),
[`Context.setLineCap()`](#Context.setLineCap), [`Context.setDash()`](#Context.setDash), and
[`Context.strokePreserve()`](#Context.strokePreserve).

Note: Degenerate segments and sub-paths are treated specially and
provide a useful result. These can result in two different
situations:

1. Zero-length "on" segments set in [`Context.setDash()`](#Context.setDash). If the cap
style is [`"round"`](enums.md#LineCap) or [`"square"`](enums.md#LineCap) then these
segments will be drawn as circular dots or squares respectively. In
the case of [`"square"`](enums.md#LineCap), the orientation of the squares
is determined by the direction of the underlying path.

2. A sub-path created by [`Context.moveTo()`](#Context.moveTo) followed by either a
[`Context.closePath()`](#Context.closePath) or one or more calls to [`Context.lineTo()`](#Context.lineTo) to the
same coordinate as the [`Context.moveTo()`](#Context.moveTo). If the cap style is
[`"round"`](enums.md#LineCap) then these sub-paths will be drawn as circular
dots. Note that in the case of [`"square"`](enums.md#LineCap) a degenerate
sub-path will not be drawn at all, (since the correct orientation
is indeterminate).

In no case will a cap style of [`"butt"`](enums.md#LineCap) cause anything
to be drawn in the case of either degenerate segments or sub-paths.

<a name="Context.strokePreserve"></a>
#### Context.strokePreserve()

A drawing operator that strokes the current path according to the
current line width, line join, line cap, and dash settings. Unlike
[`Context.stroke()`](#Context.stroke), [`Context.strokePreserve()`](#Context.strokePreserve) preserves the path within the
cairo context.

See [`Context.setLineWidth()`](#Context.setLineWidth), [`Context.setLineJoin()`](#Context.setLineJoin),
[`Context.setLineCap()`](#Context.setLineCap), [`Context.setDash()`](#Context.setDash), and
[`Context.strokePreserve()`](#Context.strokePreserve).

<a name="Context.strokeExtents"></a>
#### Context.strokeExtents()

Computes a bounding box in user coordinates covering the area that
would be affected, (the "inked" area), by a [`Context.stroke()`](#Context.stroke)
operation given the current path and stroke parameters.
If the current path is empty, returns an empty rectangle ((0,0), (0,0)).
Surface dimensions and clipping are not taken into account.

Note that if the line width is set to exactly zero, then
[`Context.strokeExtents()`](#Context.strokeExtents) will return an empty rectangle. Contrast with
[`Path.extents()`](path.md#Path.extents) which can be used to compute the non-empty
bounds as the line width approaches zero.

Note that [`Context.strokeExtents()`](#Context.strokeExtents) must necessarily do more work to
compute the precise inked areas in light of the stroke parameters,
so [`Path.extents()`](path.md#Path.extents) may be more desirable for sake of
performance if non-inked path extents are desired.

See [`Context.stroke()`](#Context.stroke), [`Context.setLineWidth()`](#Context.setLineWidth), [`Context.setLineJoin()`](#Context.setLineJoin),
[`Context.setLineCap()`](#Context.setLineCap), [`Context.setDash()`](#Context.setDash), and
[`Context.strokePreserve()`](#Context.strokePreserve).

<a name="Context.inStroke"></a>
#### Context.inStroke()

Tests whether the given point is inside the area that would be
affected by a [`Context.stroke()`](#Context.stroke) operation given the current path and
stroking parameters. Surface dimensions and clipping are not taken
into account.

See [`Context.stroke()`](#Context.stroke), [`Context.setLineWidth()`](#Context.setLineWidth), [`Context.setLineJoin()`](#Context.setLineJoin),
[`Context.setLineCap()`](#Context.setLineCap), [`Context.setDash()`](#Context.setDash), and
[`Context.strokePreserve()`](#Context.strokePreserve).

_Return value_: A non-zero value if the point is inside, or zero if
outside.

<a name="Context.copyPage"></a>
#### Context.copyPage()

Emits the current page for backends that support multiple pages, but
doesn't clear it, so, the contents of the current page will be retained
for the next page too.  Use [`Context.showPage()`](#Context.showPage) if you want to get an
empty page after the emission.

This is a convenience function that simply calls
[`Surface.copyPage()`](surface.md#Surface.copyPage) on `cr`'s target.

<a name="Context.showPage"></a>
#### Context.showPage()

Emits and clears the current page for backends that support multiple
pages.  Use [`Context.copyPage()`](#Context.copyPage) if you don't want to clear the page.

This is a convenience function that simply calls
[`Surface.showPage()`](surface.md#Surface.showPage) on `cr`'s target.


### Paths

<a name="Context.copyPath"></a>
#### Context.copyPath()

Creates a copy of the current path and returns it to the user as a
[`Path`](path.md#Path). See [`cairo_path_data_t`](#cairo_path_data_t) for hints on how to iterate
over the returned data structure.

This function will always return a valid pointer, but the result
will have no data (`data==`nil`` and
`num_data==0`), if either of the following
conditions hold:

<orderedlist>
<listitem>If there is insufficient memory to copy the path. In this
case `path->status` will be set to
[`"no-memory"`](enums.md#Status).</listitem>
<listitem>If `cr` is already in an error state. In this case
`path->status` will contain the same status that
would be returned by [`Context.status()`](#Context.status).</listitem>
</orderedlist>

_Return value_: the copy of the current path. The caller owns the
returned object and should call [`Path.destroy()`](path.md#Path.destroy) when finished
with it.

<a name="Context.copyPathFlat"></a>
#### Context.copyPathFlat()

Gets a flattened copy of the current path and returns it to the
user as a [`Path`](path.md#Path). See [`cairo_path_data_t`](#cairo_path_data_t) for hints on
how to iterate over the returned data structure.

This function is like [`Context.copyPath()`](#Context.copyPath) except that any curves
in the path will be approximated with piecewise-linear
approximations, (accurate to within the current tolerance
value). That is, the result is guaranteed to not have any elements
of type [`"path-curve-to"`](enums.md#) which will instead be replaced by a
series of [`"path-line-to"`](enums.md#) elements.

This function will always return a valid pointer, but the result
will have no data (`data==`nil`` and
`num_data==0`), if either of the following
conditions hold:

<orderedlist>
<listitem>If there is insufficient memory to copy the path. In this
case `path->status` will be set to
[`"no-memory"`](enums.md#Status).</listitem>
<listitem>If `cr` is already in an error state. In this case
`path->status` will contain the same status that
would be returned by [`Context.status()`](#Context.status).</listitem>
</orderedlist>

_Return value_: the copy of the current path. The caller owns the
returned object and should call [`Path.destroy()`](path.md#Path.destroy) when finished
with it.

<a name="Context.appendPath"></a>
#### Context.appendPath()

Append the `path` onto the current path. The `path` may be either the
return value from one of [`Context.copyPath()`](#Context.copyPath) or
[`Context.copyPathFlat()`](#Context.copyPathFlat) or it may be constructed manually.  See
[`Path`](path.md#Path) for details on how the path data structure should be
initialized, and note that `path->status` must be
initialized to [`"success"`](enums.md#Status).

<a name="Context.hasCurrentPoint"></a>
#### Context.hasCurrentPoint()

Returns whether a current point is defined on the current path.
See [`Context.getCurrentPoint()`](#Context.getCurrentPoint) for details on the current point.

_Return value_: whether a current point is defined.

<a name="Context.getCurrentPoint"></a>
#### Context.getCurrentPoint()

Gets the current point of the current path, which is
conceptually the final point reached by the path so far.

The current point is returned in the user-space coordinate
system. If there is no defined current point or if `cr` is in an
error status, `x` and `y` will both be set to 0.0. It is possible to
check this in advance with [`Context.hasCurrentPoint()`](#Context.hasCurrentPoint).

Most path construction functions alter the current point. See the
following for details on how they affect the current point:
[`Context.newPath()`](#Context.newPath), [`Context.newSubPath()`](#Context.newSubPath),
[`Context.appendPath()`](#Context.appendPath), [`Context.closePath()`](#Context.closePath),
[`Context.moveTo()`](#Context.moveTo), [`Context.lineTo()`](#Context.lineTo), [`Context.curveTo()`](#Context.curveTo),
[`Context.relMoveTo()`](#Context.relMoveTo), [`Context.relLineTo()`](#Context.relLineTo), [`Context.relCurveTo()`](#Context.relCurveTo),
[`Context.arc()`](#Context.arc), [`Context.arcNegative()`](#Context.arcNegative), [`Context.rectangle()`](#Context.rectangle),
[`Context.textPath()`](#Context.textPath), [`Context.glyphPath()`](#Context.glyphPath), [`Context.strokeToPath()`](#Context.strokeToPath).

Some functions use and alter the current point but do not
otherwise change current path:
[`Context.showText()`](#Context.showText).

Some functions unset the current path and as a result, current point:
[`Context.fill()`](#Context.fill), [`Context.stroke()`](#Context.stroke).

<a name="Context.newPath"></a>
#### Context.newPath()

Clears the current path. After this call there will be no path and
no current point.

<a name="Context.newSubPath"></a>
#### Context.newSubPath()

Begin a new sub-path. Note that the existing path is not
affected. After this call there will be no current point.

In many cases, this call is not needed since new sub-paths are
frequently started with [`Context.moveTo()`](#Context.moveTo).

A call to [`Context.newSubPath()`](#Context.newSubPath) is particularly useful when
beginning a new sub-path with one of the [`Context.arc()`](#Context.arc) calls. This
makes things easier as it is no longer necessary to manually
compute the arc's initial coordinates for a call to
[`Context.moveTo()`](#Context.moveTo).

<a name="Context.closePath"></a>
#### Context.closePath()

Adds a line segment to the path from the current point to the
beginning of the current sub-path, (the most recent point passed to
[`Context.moveTo()`](#Context.moveTo)), and closes this sub-path. After this call the
current point will be at the joined endpoint of the sub-path.

The behavior of [`Context.closePath()`](#Context.closePath) is distinct from simply calling
[`Context.lineTo()`](#Context.lineTo) with the equivalent coordinate in the case of
stroking. When a closed sub-path is stroked, there are no caps on
the ends of the sub-path. Instead, there is a line join connecting
the final and initial segments of the sub-path.

If there is no current point before the call to [`Context.closePath()`](#Context.closePath),
this function will have no effect.

Note: As of cairo version 1.2.4 any call to [`Context.closePath()`](#Context.closePath) will
place an explicit MOVE_TO element into the path immediately after
the CLOSE_PATH element, (which can be seen in [`Context.copyPath()`](#Context.copyPath) for
example). This can simplify path processing in some cases as it may
not be necessary to save the "last move_to point" during processing
as the MOVE_TO immediately after the CLOSE_PATH will provide that
point.

<a name="Context.arc"></a>
#### Context.arc()

Adds a circular arc of the given `radius` to the current path.  The
arc is centered at (`xc`, `yc`), begins at `angle1` and proceeds in
the direction of increasing angles to end at `angle2`. If `angle2` is
less than `angle1` it will be progressively increased by
`2*M_PI` until it is greater than `angle1`.

If there is a current point, an initial line segment will be added
to the path to connect the current point to the beginning of the
arc. If this initial line is undesired, it can be avoided by
calling [`Context.newSubPath()`](#Context.newSubPath) before calling [`Context.arc()`](#Context.arc).

Angles are measured in radians. An angle of 0.0 is in the direction
of the positive X axis (in user space). An angle of
`M_PI/2.0` radians (90 degrees) is in the
direction of the positive Y axis (in user space). Angles increase
in the direction from the positive X axis toward the positive Y
axis. So with the default transformation matrix, angles increase in
a clockwise direction.

(To convert from degrees to radians, use `degrees * (M_PI / 180.)`.)

This function gives the arc in the direction of increasing angles;
see [`Context.arcNegative()`](#Context.arcNegative) to get the arc in the direction of
decreasing angles.

The arc is circular in user space. To achieve an elliptical arc,
you can scale the current transformation matrix by different
amounts in the X and Y directions. For example, to draw an ellipse
in the box given by `x`, `y`, `width`, `height`:

```lua
cairo_save (cr);
cairo_translate (cr, x + width / 2., y + height / 2.);
cairo_scale (cr, width / 2., height / 2.);
cairo_arc (cr, 0., 0., 1., 0., 2 * M_PI);
cairo_restore (cr);
```

<a name="Context.arcNegative"></a>
#### Context.arcNegative()

Adds a circular arc of the given `radius` to the current path.  The
arc is centered at (`xc`, `yc`), begins at `angle1` and proceeds in
the direction of decreasing angles to end at `angle2`. If `angle2` is
greater than `angle1` it will be progressively decreased by
`2*M_PI` until it is less than `angle1`.

See [`Context.arc()`](#Context.arc) for more details. This function differs only in the
direction of the arc between the two angles.

<a name="Context.curveTo"></a>
#### Context.curveTo()

Adds a cubic Bézier spline to the path from the current point to
position (`x3`, `y3`) in user-space coordinates, using (`x1`, `y1`) and
(`x2`, `y2`) as the control points. After this call the current point
will be (`x3`, `y3`).

If there is no current point before the call to [`Context.curveTo()`](#Context.curveTo)
this function will behave as if preceded by a call to
cairo_move_to(`cr`, `x1`, `y1`).

<a name="Context.lineTo"></a>
#### Context.lineTo()

Adds a line to the path from the current point to position (`x`, `y`)
in user-space coordinates. After this call the current point
will be (`x`, `y`).

If there is no current point before the call to [`Context.lineTo()`](#Context.lineTo)
this function will behave as cairo_move_to(`cr`, `x`, `y`).

<a name="Context.moveTo"></a>
#### Context.moveTo()

Begin a new sub-path. After this call the current point will be (`x`,
`y`).

<a name="Context.rectangle"></a>
#### Context.rectangle()

Adds a closed sub-path rectangle of the given size to the current
path at position (`x`, `y`) in user-space coordinates.

This function is logically equivalent to:
```lua
cairo_move_to (cr, x, y);
cairo_rel_line_to (cr, width, 0);
cairo_rel_line_to (cr, 0, height);
cairo_rel_line_to (cr, -width, 0);
cairo_close_path (cr);
```

<a name="Context.glyphPath"></a>
#### Context.glyphPath()

Adds closed paths for the glyphs to the current path.  The generated
path if filled, achieves an effect similar to that of
[`Context.showGlyphs()`](#Context.showGlyphs).

<a name="Context.textPath"></a>
#### Context.textPath()

Adds closed paths for text to the current path.  The generated
path if filled, achieves an effect similar to that of
[`Context.showText()`](#Context.showText).

Text conversion and positioning is done similar to [`Context.showText()`](#Context.showText).

Like [`Context.showText()`](#Context.showText), After this call the current point is
moved to the origin of where the next glyph would be placed in
this same progression.  That is, the current point will be at
the origin of the final glyph offset by its advance values.
This allows for chaining multiple calls to to [`Context.textPath()`](#Context.textPath)
without having to set current point in between.

Note: The [`Context.textPath()`](#Context.textPath) function call is part of what the cairo
designers call the "toy" text API. It is convenient for short demos
and simple programs, but it is not expected to be adequate for
serious text-using applications. See [`Context.glyphPath()`](#Context.glyphPath) for the
"real" text path API in cairo.

<a name="Context.relCurveTo"></a>
#### Context.relCurveTo()

Relative-coordinate version of [`Context.curveTo()`](#Context.curveTo). All offsets are
relative to the current point. Adds a cubic Bézier spline to the
path from the current point to a point offset from the current
point by (`dx3`, `dy3`), using points offset by (`dx1`, `dy1`) and
(`dx2`, `dy2`) as the control points. After this call the current
point will be offset by (`dx3`, `dy3`).

Given a current point of (x, y), cairo_rel_curve_to(`cr`, `dx1`,
`dy1`, `dx2`, `dy2`, `dx3`, `dy3`) is logically equivalent to
cairo_curve_to(`cr`, x+`dx1`, y+`dy1`, x+`dx2`, y+`dy2`, x+`dx3`, y+`dy3`).

It is an error to call this function with no current point. Doing
so will cause `cr` to shutdown with a status of
[`"no-current-point"`](enums.md#Status).

<a name="Context.relLineTo"></a>
#### Context.relLineTo()

Relative-coordinate version of [`Context.lineTo()`](#Context.lineTo). Adds a line to the
path from the current point to a point that is offset from the
current point by (`dx`, `dy`) in user space. After this call the
current point will be offset by (`dx`, `dy`).

Given a current point of (x, y), cairo_rel_line_to(`cr`, `dx`, `dy`)
is logically equivalent to cairo_line_to(`cr`, x + `dx`, y + `dy`).

It is an error to call this function with no current point. Doing
so will cause `cr` to shutdown with a status of
[`"no-current-point"`](enums.md#Status).

<a name="Context.relMoveTo"></a>
#### Context.relMoveTo()

Begin a new sub-path. After this call the current point will offset
by (`x`, `y`).

Given a current point of (x, y), cairo_rel_move_to(`cr`, `dx`, `dy`)
is logically equivalent to cairo_move_to(`cr`, x + `dx`, y + `dy`).

It is an error to call this function with no current point. Doing
so will cause `cr` to shutdown with a status of
[`"no-current-point"`](enums.md#Status).


### Transformations

<a name="Context.translate"></a>
#### Context.translate()

Modifies the current transformation matrix (CTM) by translating the
user-space origin by (`tx`, `ty`). This offset is interpreted as a
user-space coordinate according to the CTM in place before the new
call to [`Context.translate()`](#Context.translate). In other words, the translation of the
user-space origin takes place after any existing transformation.

<a name="Context.scale"></a>
#### Context.scale()

Modifies the current transformation matrix (CTM) by scaling the X
and Y user-space axes by `sx` and `sy` respectively. The scaling of
the axes takes place after any existing transformation of user
space.

<a name="Context.rotate"></a>
#### Context.rotate()

Modifies the current transformation matrix (CTM) by rotating the
user-space axes by `angle` radians. The rotation of the axes takes
places after any existing transformation of user space. The
rotation direction for positive angles is from the positive X axis
toward the positive Y axis.

<a name="Context.transform"></a>
#### Context.transform()

Modifies the current transformation matrix (CTM) by applying
`matrix` as an additional transformation. The new transformation of
user space takes place after any existing transformation.

<a name="Context.setMatrix"></a>
#### Context.setMatrix()

Modifies the current transformation matrix (CTM) by setting it
equal to `matrix`.

<a name="Context.getMatrix"></a>
#### Context.getMatrix()

Stores the current transformation matrix (CTM) into `matrix`.

<a name="Context.identityMatrix"></a>
#### Context.identityMatrix()

Resets the current transformation matrix (CTM) by setting it equal
to the identity matrix. That is, the user-space and device-space
axes will be aligned and one user-space unit will transform to one
device-space unit.

<a name="Context.userToDevice"></a>
#### Context.userToDevice()

Transform a coordinate from user space to device space by
multiplying the given point by the current transformation matrix
(CTM).

<a name="Context.userToDeviceDistance"></a>
#### Context.userToDeviceDistance()

Transform a distance vector from user space to device space. This
function is similar to [`Context.userToDevice()`](#Context.userToDevice) except that the
translation components of the CTM will be ignored when transforming
(`dx`,`dy`).

<a name="Context.deviceToUser"></a>
#### Context.deviceToUser()

Transform a coordinate from device space to user space by
multiplying the given point by the inverse of the current
transformation matrix (CTM).

<a name="Context.deviceToUserDistance"></a>
#### Context.deviceToUserDistance()

Transform a distance vector from device space to user space. This
function is similar to [`Context.deviceToUser()`](#Context.deviceToUser) except that the
translation components of the inverse CTM will be ignored when
transforming (`dx`,`dy`).


### Rendering text and glyphs

<a name="Context.selectFontFace"></a>
#### Context.selectFontFace()

Note: The [`Context.selectFontFace()`](#Context.selectFontFace) function call is part of what
the cairo designers call the "toy" text API. It is convenient for
short demos and simple programs, but it is not expected to be
adequate for serious text-using applications.

Selects a family and style of font from a simplified description as
a family name, slant and weight. Cairo provides no operation to
list available family names on the system (this is a "toy",
remember), but the standard CSS2 generic family names, ("serif",
"sans-serif", "cursive", "fantasy", "monospace"), are likely to
work as expected.

If `family` starts with the string "`cairo`:", or if no native font
backends are compiled in, cairo will use an internal font family.
The internal font family recognizes many modifiers in the `family`
string, most notably, it recognizes the string "monospace".  That is,
the family name "`cairo`:monospace" will use the monospace version of
the internal font family.

For "real" font selection, see the font-backend-specific
font_face_create functions for the font backend you are using. (For
example, if you are using the freetype-based cairo-ft font backend,
see [`Context.ftFontFaceCreateForFtFace()`](#Context.ftFontFaceCreateForFtFace) or
[`Context.ftFontFaceCreateForPattern()`](#Context.ftFontFaceCreateForPattern).) The resulting font face
could then be used with [`ScaledFontFace.new()`](fontface.md#ScaledFontFace.new) and
[`Context.setScaledFont()`](#Context.setScaledFont).

Similarly, when using the "real" font support, you can call
directly into the underlying font system, (such as fontconfig or
freetype), for operations such as listing available fonts, etc.

It is expected that most applications will need to use a more
comprehensive font handling and text layout library, (for example,
pango), in conjunction with cairo.

If text is drawn without a call to [`Context.selectFontFace()`](#Context.selectFontFace), (nor
[`Context.setFontFace()`](#Context.setFontFace) nor [`Context.setScaledFont()`](#Context.setScaledFont)), the default
family is platform-specific, but is essentially "sans-serif".
Default slant is [`"normal"`](enums.md#FontSlant), and default weight is
[`"normal"`](enums.md#FontWeight).

This function is equivalent to a call to [`Context.toyFontFaceCreate()`](#Context.toyFontFaceCreate)
followed by [`Context.setFontFace()`](#Context.setFontFace).

<a name="Context.setFontSize"></a>
#### Context.setFontSize()

Sets the current font matrix to a scale by a factor of `size`, replacing
any font matrix previously set with [`Context.setFontSize()`](#Context.setFontSize) or
[`Context.setFontMatrix()`](#Context.setFontMatrix). This results in a font size of `size` user space
units. (More precisely, this matrix will result in the font's
em-square being a `size` by `size` square in user space.)

If text is drawn without a call to [`Context.setFontSize()`](#Context.setFontSize), (nor
[`Context.setFontMatrix()`](#Context.setFontMatrix) nor [`Context.setScaledFont()`](#Context.setScaledFont)), the default
font size is 10.0.

<a name="Context.setFontMatrix"></a>
#### Context.setFontMatrix()

Sets the current font matrix to `matrix`. The font matrix gives a
transformation from the design space of the font (in this space,
the em-square is 1 unit by 1 unit) to user space. Normally, a
simple scale is used (see [`Context.setFontSize()`](#Context.setFontSize)), but a more
complex font matrix can be used to shear the font
or stretch it unequally along the two axes

<a name="Context.getFontMatrix"></a>
#### Context.getFontMatrix()

Stores the current font matrix into `matrix`. See
[`Context.setFontMatrix()`](#Context.setFontMatrix).

<a name="Context.setFontOptions"></a>
#### Context.setFontOptions()

Sets a set of custom font rendering options for the [`Context`](#Context).
Rendering options are derived by merging these options with the
options derived from underlying surface; if the value in `options`
has a default value (like [`"default"`](enums.md#Antialias)), then the value
from the surface is used.

<a name="Context.getFontOptions"></a>
#### Context.getFontOptions()

Retrieves font rendering options set via [`cairo_set_font_options`](#cairo_set_font_options).
Note that the returned options do not include any options derived
from the underlying surface; they are literally the options
passed to [`Context.setFontOptions()`](#Context.setFontOptions).

<a name="Context.setFontFace"></a>
#### Context.setFontFace()

Replaces the current [`FontFace`](fontface.md#FontFace) object in the [`Context`](#Context) with
`font_face`. The replaced font face in the [`Context`](#Context) will be
destroyed if there are no other references to it.

<a name="Context.getFontFace"></a>
#### Context.getFontFace()

Gets the current font face for a [`Context`](#Context).

_Return value_: the current font face.  This object is owned by
cairo. To keep a reference to it, you must call
[`FontFace.reference()`](fontface.md#FontFace.reference).

This function never returns `nil`. If memory cannot be allocated, a
special "nil" [`FontFace`](fontface.md#FontFace) object will be returned on which
[`FontFace.status()`](fontface.md#FontFace.status) returns [`"no-memory"`](enums.md#Status). Using
this nil object will cause its error state to propagate to other
objects it is passed to, (for example, calling
[`Context.setFontFace()`](#Context.setFontFace) with a nil font will trigger an error that
will shutdown the [`Context`](#Context) object).

<a name="Context.setScaledFont"></a>
#### Context.setScaledFont()

Replaces the current font face, font matrix, and font options in
the [`Context`](#Context) with those of the [`ScaledFontFace`](fontface.md#ScaledFontFace).  Except for
some translation, the current CTM of the [`Context`](#Context) should be the
same as that of the [`ScaledFontFace`](fontface.md#ScaledFontFace), which can be accessed
using [`ScaledFontFace.getCtm()`](fontface.md#ScaledFontFace.getCtm).

<a name="Context.getScaledFont"></a>
#### Context.getScaledFont()

Gets the current scaled font for a [`Context`](#Context).

_Return value_: the current scaled font. This object is owned by
cairo. To keep a reference to it, you must call
[`ScaledFontFace.reference()`](fontface.md#ScaledFontFace.reference).

This function never returns `nil`. If memory cannot be allocated, a
special "nil" [`ScaledFontFace`](fontface.md#ScaledFontFace) object will be returned on which
[`ScaledFontFace.status()`](fontface.md#ScaledFontFace.status) returns [`"no-memory"`](enums.md#Status). Using
this nil object will cause its error state to propagate to other
objects it is passed to, (for example, calling
[`Context.setScaledFont()`](#Context.setScaledFont) with a nil font will trigger an error that
will shutdown the [`Context`](#Context) object).

<a name="Context.showText"></a>
#### Context.showText()

A drawing operator that generates the shape from a string of UTF-8
characters, rendered according to the current font_face, font_size
(font_matrix), and font_options.

This function first computes a set of glyphs for the string of
text. The first glyph is placed so that its origin is at the
current point. The origin of each subsequent glyph is offset from
that of the previous glyph by the advance values of the previous
glyph.

After this call the current point is moved to the origin of where
the next glyph would be placed in this same progression. That is,
the current point will be at the origin of the final glyph offset
by its advance values. This allows for easy display of a single
logical string with multiple calls to [`Context.showText()`](#Context.showText).

Note: The [`Context.showText()`](#Context.showText) function call is part of what the cairo
designers call the "toy" text API. It is convenient for short demos
and simple programs, but it is not expected to be adequate for
serious text-using applications. See [`Context.showGlyphs()`](#Context.showGlyphs) for the
"real" text display API in cairo.

<a name="Context.showGlyphs"></a>
#### Context.showGlyphs()

A drawing operator that generates the shape from an array of glyphs,
rendered according to the current font face, font size
(font matrix), and font options.

<a name="Context.showTextGlyphs"></a>
#### Context.showTextGlyphs()

This operation has rendering effects similar to [`Context.showGlyphs()`](#Context.showGlyphs)
but, if the target surface supports it, uses the provided text and
cluster mapping to embed the text for the glyphs shown in the output.
If the target does not support the extended attributes, this function
acts like the basic [`Context.showGlyphs()`](#Context.showGlyphs) as if it had been passed
`glyphs` and `num_glyphs`.

The mapping between `utf8` and `glyphs` is provided by an array of
clusters.  Each cluster covers a number of
text bytes and glyphs, and neighboring clusters cover neighboring
areas of `utf8` and `glyphs`.  The clusters should collectively cover `utf8`
and `glyphs` in entirety.

The first cluster always covers bytes from the beginning of `utf8`.
If `cluster_flags` do not have the [`"backward"`](enums.md#TextClusterFlags)
set, the first cluster also covers the beginning
of `glyphs`, otherwise it covers the end of the `glyphs` array and
following clusters move backward.

See [`cairo_text_cluster_t`](#cairo_text_cluster_t) for constraints on valid clusters.

<a name="Context.fontExtents"></a>
#### Context.fontExtents()

Gets the font extents for the currently selected font.

<a name="Context.textExtents"></a>
#### Context.textExtents()

Gets the extents for a string of text. The extents describe a
user-space rectangle that encloses the "inked" portion of the text,
(as it would be drawn by [`Context.showText()`](#Context.showText)). Additionally, the
x_advance and y_advance values indicate the amount by which the
current point would be advanced by [`Context.showText()`](#Context.showText).

Note that whitespace characters do not directly contribute to the
size of the rectangle (extents.width and extents.height). They do
contribute indirectly by changing the position of non-whitespace
characters. In particular, trailing whitespace characters are
likely to not affect the size of the rectangle, though they will
affect the x_advance and y_advance values.

<a name="Context.glyphExtents"></a>
#### Context.glyphExtents()

Gets the extents for an array of glyphs. The extents describe a
user-space rectangle that encloses the "inked" portion of the
glyphs, (as they would be drawn by [`Context.showGlyphs()`](#Context.showGlyphs)).
Additionally, the x_advance and y_advance values indicate the
amount by which the current point would be advanced by
[`Context.showGlyphs()`](#Context.showGlyphs).

Note that whitespace glyphs do not contribute to the size of the
rectangle (extents.width and extents.height).

