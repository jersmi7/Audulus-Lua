-- Demo using the text bounding box (text_bounds). 
-- Anchor text to any corner or center of a rectangle.


-- Define a rectangle for anchoring the text
-- This rectangle is set to canvas node size, but it doesn't have to be
-- As with any rectangle in Audulus canvas node, 
-- x0, y0 is bottom left, x1, y1 is top right
x0, y0, x1, y1 = 0, 0, canvas_width, canvas_height

function rectangleGuide()
    stroke_rect({x0, y0}, {x1, y1}, 0, 0.5, color_paint(theme.redHighlight))
end

rectangleGuide()

function anchorText(myText, anchor)        
    text_size = 2
    min, max = text_bounds(myText)
    cx = (x0 + x1) / 2
    cy = (y0 + y1) / 2

    local anchor_offsets = {
        topLeft 	 = {x0, y1, 0, -max[2]},
        topCenter 	 = {cx, y1, -(min[1] + max[1])/2, -max[2]},
        topRight 	 = {x1, y1, -max[1], -max[2]},
        centerLeft 	 = {x0, cy, 0, -(min[2] + max[2])/2},
        center 		 = {cx, cy, -(min[1] + max[1])/2, -(min[2] + max[2])/2},
        centerRight  = {x1, cy, -max[1], -(min[2] + max[2])/2},
        bottomLeft 	 = {x0, y0, 0, 0},
        bottomCenter = {cx, y0, -(min[1] + max[1])/2, 0},
        bottomRight  = {x1, y0, -max[1], 0}
    }

    save()
    translate{anchor_offsets[anchor][1], anchor_offsets[anchor][2]}
    scale{text_size, text_size}
    translate{anchor_offsets[anchor][3], anchor_offsets[anchor][4]}
    text(myText, theme.text)
    restore()
end

anchorText("TL", "topLeft")
anchorText("TC", "topCenter")
anchorText("TR", "topRight")
anchorText("CL", "centerLeft")
anchorText("C", "center")
anchorText("CR", "centerRight")
anchorText("BL", "bottomLeft")
anchorText("BC", "bottomCenter")
anchorText("BR", "bottomRight")
