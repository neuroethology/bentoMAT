function sliderCheck(source,~,parent)
% if the user interacts with the slider, this function modifies the
% gui.Action flag, so that the gui is updated appropriately.

gui    = guidata(parent);

switch source.Tag
    case 'leftArrow'
        gui.Action = -gui.ctrl.slider.SliderStep(1);   %left arrow
    case 'rightArrow'
        gui.Action = gui.ctrl.slider.SliderStep(1);    %right arrow
    case 'bar'
        pClick  = get(0,'pointerlocation');
        
        tracker = getpixelposition(gui.ctrl.slider.Marker,true);
        tracker(1) = gui.h0.Position(1) + tracker(1);
              
        if(pClick(1) < tracker(1))
            gui.Action = -gui.ctrl.slider.SliderStep(2);   %track left
        elseif(pClick(1) > tracker(1)+tracker(3))
            gui.Action = gui.ctrl.slider.SliderStep(2);    %track right
        end
        
    case 'marker'
        gui.Action = 'drag';
end

guidata(parent,gui);