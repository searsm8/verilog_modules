
/*addPinLabels gets all pins in the current cell view, then creates a label on the label layer on that pin*/
procedure(addPinLabels(@key (cv geGetEditCellView()) (layerName "text") (height 0.4) (orient "R0") (justification "centerCenter") (font "stick"))

foreach(term cv~>terminals  ;~>pins  /for each pin in the cell view*/
printf("Adding label for pin %s\n" term~>name)

/*create a new label for each pin*/
new_label = dbCreateLabel(cv caar(term~>pins~>figs~>layerName) caaar(term~>pins~>figs~>bBox) term~>name justification orient font height)

/*Set the label to the "lbl" layer*/
new_label~>lpp = (list new_label~>layerName "label")
)
println("*********************************************")
println("Done!")
t
)
