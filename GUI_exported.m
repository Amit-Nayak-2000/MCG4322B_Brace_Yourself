classdef GUI_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                        matlab.ui.Figure
        YoudeservetostepintocomfortLabel  matlab.ui.control.Label
        ExitDesignerButton              matlab.ui.control.Button
        BUILDButton                     matlab.ui.control.Button
        PleaseenterusermeasurementsPanel  matlab.ui.container.Panel
        EditField_c                     matlab.ui.control.NumericEditField
        EditField_t                     matlab.ui.control.NumericEditField
        EditField_w                     matlab.ui.control.NumericEditField
        EditField_h                     matlab.ui.control.NumericEditField
        CalfCircumferencecmSlider       matlab.ui.control.Slider
        CalfCircumferencecmSliderLabel  matlab.ui.control.Label
        WeightKgSlider                  matlab.ui.control.Slider
        WeightKgSliderLabel             matlab.ui.control.Label
        ThighCircumferencecmSlider      matlab.ui.control.Slider
        ThighCircumferencecmSliderLabel  matlab.ui.control.Label
        HeightcmSlider                  matlab.ui.control.Slider
        HeightcmSliderLabel             matlab.ui.control.Label
        Image                           matlab.ui.control.Image
        TabGroup                        matlab.ui.container.TabGroup
        OutputLogTab                    matlab.ui.container.Tab
        TextArea                        matlab.ui.control.TextArea
        SFTab                           matlab.ui.container.Tab
        TextArea_sf                     matlab.ui.control.TextArea
        ContributionTab                 matlab.ui.container.Tab
        UIAxes                          matlab.ui.control.UIAxes
        ICRTab                          matlab.ui.container.Tab
        UIAxes2                         matlab.ui.control.UIAxes
        AboutUsTab                      matlab.ui.container.Tab
        Image2                          matlab.ui.control.Image
    end

    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
%             % Initialize global variables
%             app.height = 100;  
%             app.weight = 36; 
        end

        % Value changing function: HeightcmSlider
        function HeightSliderValueChanging(app, event)
            userheight = event.Value;
            if (userheight < 100) || (userheight > 200) %If statement to display error message in output log if inputs are outside of specified range.
                app.TextArea.Value = 'Invalid Entry. Please enter a height between 100 cm and 200 cm';
            else
                app.EditField_h.Value = userheight; %Sets text field equal to slider value
                app.TextArea.Value = 'Click BUILD to submit design inputs. Click Exit Designer to close the GUI.'
            end
        end

        % Value changed function: EditField_h
        function heightTextValueChanged(app, event)
            userheighttext = app.EditField_h.Value;
            if (userheighttext < 100) || (userheighttext > 200) %If statement to check if inputs are within specified range
                app.TextArea.Value = 'Invalid Entry. Please enter a height between 100 cm and 200 cm';
            else
                app.HeightcmSlider.Value = userheighttext; %Sets slider value equal to text box input
                app.TextArea.Value = 'Click Generate to submit design inputs. Click Finish to exit the GUI.';
            end
        end

        % Value changing function: WeightKgSlider
        function WeightSliderValueChanging(app, event)
            userweight = event.Value;
            if (userweight < 36) || (userweight > 115) %If statement to display error message in output log if inputs are outside of specified range.
                app.TextArea.Value = 'Invalid Entry. Please enter a weight between 36 kg and 115 kg';
            else
                app.EditField_w.Value = userweight; %Sets text field equal to slider value
                app.TextArea.Value = 'Click BUILD to submit design inputs. Click Exit Designer to close the GUI.'
            end
            
        end

        % Value changed function: EditField_w
        function weightTextValueChanged(app, event)
            userweighttext = app.EditField_w.Value;
            if (userweighttext < 36) || (userweighttext > 115) %If statement to check if inputs are within specified range
                app.TextArea.Value = 'Invalid Entry. Please enter a weight between 36 kg and 115 kg';
            else
                app.WeightKgSlider.Value = userweighttext; %Sets slider value equal to text box input
                app.TextArea.Value = 'Click Generate to submit design inputs. Click Finish to exit the GUI.';
            end
        end

        % Value changing function: ThighCircumferencecmSlider
        function ThighSliderValueChanging(app, event)
            userthigh = event.Value;
            if (userthigh < 33) || (userthigh > 81) %If statement to display error message in output log if inputs are outside of specified range.
                app.TextArea.Value = 'Invalid Entry. Please enter a thigh circumference between 33 cm and 81 cm';
            else
                app.EditField_t.Value = userthigh; %Sets text field equal to slider value
                app.TextArea.Value = 'Click BUILD to submit design inputs. Click Exit Designer to close the GUI.'
            end
            
        end

        % Value changed function: EditField_t
        function thighTextValueChanged(app, event)
            userthightext = app.EditField_w.Value;
            if (userthightext < 33) || (userthightext > 81) %If statement to check if inputs are within specified range
                app.TextArea.Value = 'Invalid Entry. Please enter a thigh circumference between 33 cm and 81 cm';
            else
                app.ThighCircumferencecmSlider.Value = userthightext; %Sets slider value equal to text box input
                app.TextArea.Value = 'Click Generate to submit design inputs. Click Finish to exit the GUI.';
            end
            
        end

        % Value changing function: CalfCircumferencecmSlider
        function CalfSliderValueChanging(app, event)
            usercalf = event.Value;
            if (usercalf < 27) || (usercalf > 61) %If statement to display error message in output log if inputs are outside of specified range.
                app.TextArea.Value = 'Invalid Entry. Please enter a calf circumference between 27 cm and 61 cm';
            else
                app.EditField_c.Value = usercalf; %Sets text field equal to slider value
                app.TextArea.Value = 'Click BUILD to submit design inputs. Click Exit Designer to close the GUI.'
            end
            
        end

        % Value changed function: EditField_c
        function calfTextValueChanged(app, event)
            usercalftext = app.EditField_c.Value;
            if (usercalftext < 27) || (usercalftext > 61) %If statement to check if inputs are within specified range
                app.TextArea.Value = 'Invalid Entry. Please enter a calf circumference between 27 cm and 61 cm';
            else
                app.CalfCircumferencecmSlider.Value = usercalftext; %Sets slider value equal to text box input
                app.TextArea.Value = 'Click Generate to submit design inputs. Click Finish to exit the GUI.';
            end
        end

        % Button pushed function: BUILDButton
        function BUILDButtonPushed(app, event)
            height = app.EditField_h.Value; %Saves latest value from text box to the variable height
            weight = app.EditField_w.Value; %Saves latest value from text box to the variable weight
            calfD = app.EditField_c.Value / pi; %Saves latest value from text box to the variable calfCircumference and converts to diameter
            thighD = app.EditField_t.Value / pi; %Saves latest value from text box to the variable thighCircumference and converts to diameter

            if (height < 100) || (height > 200) || (weight < 36) || (weight > 100) || (calfC < 27) || (calfC > 61) || (thighC < 33) || (thighC > 81) %If statement to verify all three inputs are within specified ranges
                app.TextArea.Value = 'Invalid Entry. Please ensure inputs are within the specified ranges.';
%             else %If all inputs are within specified ranges, proceed to else statement
                %Main(height, weight, calfC, thighC); %Calls the design code function using input arguments from the GUI
%             
%                 %Store contents of Log file in output panel, and display
%                 %location of equations text file.
%                 log_file = 'H:\jmart231\group123\group123\Log\group123_LOG.TXT'; %Sets the string path to find log file equal to the variable log_file for easy reference
%                 solidworks_file = 'H:\jmart231\group123\group123\SolidWorks\Equations\cylinder.txt'
%                 fid = fopen(log_file,'r'); %Open the log file for reading
%                 S = char(fread(fid)'); %Read the log file into a string
%                 fclose(fid); %Close log file once finished
%             
%                 app.TextArea.Value = S; %Sets the value in the output log text box equal to the string from the log file
%                 app.EditField.Value = solidworks_file; %Displays the file path at the bottom of the GUI
            end
        end

        % Button pushed function: ExitDesignerButton
        function ExitButtonPushed(app, event)
            closereq; %Closes GUI figure
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Get the file path for locating images
            pathToMLAPP = fileparts(mfilename('fullpath'));

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Color = [0.7216 0.8588 0.851];
            app.UIFigure.Position = [100 100 807 421];
            app.UIFigure.Name = 'MATLAB App';

            % Create TabGroup
            app.TabGroup = uitabgroup(app.UIFigure);
            app.TabGroup.Position = [404 63 395 347];

            % Create OutputLogTab
            app.OutputLogTab = uitab(app.TabGroup);
            app.OutputLogTab.Title = 'Output Log';
            app.OutputLogTab.BackgroundColor = [0.0431 0.1686 0.2314];

            % Create TextArea
            app.TextArea = uitextarea(app.OutputLogTab);
            app.TextArea.Position = [11 12 374 301];
            app.TextArea.Value = {'Click BUILD to submit design inputs. '; 'Click Exit Designer to quit the GUI.'};

            % Create SFTab
            app.SFTab = uitab(app.TabGroup);
            app.SFTab.Title = 'S.F.';
            app.SFTab.BackgroundColor = [0.0392 0.1686 0.2314];

            % Create TextArea_sf
            app.TextArea_sf = uitextarea(app.SFTab);
            app.TextArea_sf.Position = [11 12 374 301];

            % Create ContributionTab
            app.ContributionTab = uitab(app.TabGroup);
            app.ContributionTab.Title = 'Contribution';
            app.ContributionTab.BackgroundColor = [0.9608 0.9608 0.9804];

            % Create UIAxes
            app.UIAxes = uiaxes(app.ContributionTab);
            title(app.UIAxes, 'Knee Moment Contribution')
            xlabel(app.UIAxes, 'Gait Cycle (%)')
            ylabel(app.UIAxes, 'Y')
            zlabel(app.UIAxes, 'Z')
            app.UIAxes.Position = [11 12 374 301];

            % Create ICRTab
            app.ICRTab = uitab(app.TabGroup);
            app.ICRTab.Title = 'ICR';
            app.ICRTab.BackgroundColor = [0.9608 0.9608 0.9804];

            % Create UIAxes2
            app.UIAxes2 = uiaxes(app.ICRTab);
            title(app.UIAxes2, 'Title')
            xlabel(app.UIAxes2, 'X')
            ylabel(app.UIAxes2, 'Y')
            zlabel(app.UIAxes2, 'Z')
            app.UIAxes2.Position = [1 1 393 322];

            % Create AboutUsTab
            app.AboutUsTab = uitab(app.TabGroup);
            app.AboutUsTab.Title = 'About Us';
            app.AboutUsTab.BackgroundColor = [0.0392 0.1686 0.2314];

            % Create Image2
            app.Image2 = uiimage(app.AboutUsTab);
            app.Image2.Position = [1 31 393 292];
            app.Image2.ImageSource = fullfile(pathToMLAPP, 'Slide64.jpg');

            % Create Image
            app.Image = uiimage(app.UIFigure);
            app.Image.ScaleMethod = 'fill';
            app.Image.Position = [18 326 166 84];
            app.Image.ImageSource = fullfile(pathToMLAPP, 'IMG_2979.png');

            % Create PleaseenterusermeasurementsPanel
            app.PleaseenterusermeasurementsPanel = uipanel(app.UIFigure);
            app.PleaseenterusermeasurementsPanel.Title = 'Please enter user measurements. ';
            app.PleaseenterusermeasurementsPanel.BackgroundColor = [0.9569 0.9569 0.9765];
            app.PleaseenterusermeasurementsPanel.Position = [18 63 360 248];

            % Create HeightcmSliderLabel
            app.HeightcmSliderLabel = uilabel(app.PleaseenterusermeasurementsPanel);
            app.HeightcmSliderLabel.HorizontalAlignment = 'right';
            app.HeightcmSliderLabel.FontName = 'NewCenturySchoolBook';
            app.HeightcmSliderLabel.Position = [5 199 136 22];
            app.HeightcmSliderLabel.Text = 'Height (cm):';

            % Create HeightcmSlider
            app.HeightcmSlider = uislider(app.PleaseenterusermeasurementsPanel);
            app.HeightcmSlider.Limits = [100 200];
            app.HeightcmSlider.ValueChangingFcn = createCallbackFcn(app, @HeightSliderValueChanging, true);
            app.HeightcmSlider.FontName = 'Bookman';
            app.HeightcmSlider.Position = [165 208 110 3];
            app.HeightcmSlider.Value = 100;

            % Create ThighCircumferencecmSliderLabel
            app.ThighCircumferencecmSliderLabel = uilabel(app.PleaseenterusermeasurementsPanel);
            app.ThighCircumferencecmSliderLabel.HorizontalAlignment = 'right';
            app.ThighCircumferencecmSliderLabel.Position = [5 95 143 22];
            app.ThighCircumferencecmSliderLabel.Text = 'Thigh Circumference (cm)';

            % Create ThighCircumferencecmSlider
            app.ThighCircumferencecmSlider = uislider(app.PleaseenterusermeasurementsPanel);
            app.ThighCircumferencecmSlider.Limits = [33 81];
            app.ThighCircumferencecmSlider.ValueChangingFcn = createCallbackFcn(app, @ThighSliderValueChanging, true);
            app.ThighCircumferencecmSlider.Position = [165 105 114 3];
            app.ThighCircumferencecmSlider.Value = 33;

            % Create WeightKgSliderLabel
            app.WeightKgSliderLabel = uilabel(app.PleaseenterusermeasurementsPanel);
            app.WeightKgSliderLabel.HorizontalAlignment = 'right';
            app.WeightKgSliderLabel.Position = [5 148 136 22];
            app.WeightKgSliderLabel.Text = 'Weight (Kg):';

            % Create WeightKgSlider
            app.WeightKgSlider = uislider(app.PleaseenterusermeasurementsPanel);
            app.WeightKgSlider.Limits = [36 115];
            app.WeightKgSlider.ValueChangingFcn = createCallbackFcn(app, @WeightSliderValueChanging, true);
            app.WeightKgSlider.Position = [165 157 110 3];
            app.WeightKgSlider.Value = 36;

            % Create CalfCircumferencecmSliderLabel
            app.CalfCircumferencecmSliderLabel = uilabel(app.PleaseenterusermeasurementsPanel);
            app.CalfCircumferencecmSliderLabel.HorizontalAlignment = 'right';
            app.CalfCircumferencecmSliderLabel.Position = [5 43 136 22];
            app.CalfCircumferencecmSliderLabel.Text = 'Calf Circumference (cm)';

            % Create CalfCircumferencecmSlider
            app.CalfCircumferencecmSlider = uislider(app.PleaseenterusermeasurementsPanel);
            app.CalfCircumferencecmSlider.Limits = [27 61];
            app.CalfCircumferencecmSlider.ValueChangingFcn = createCallbackFcn(app, @CalfSliderValueChanging, true);
            app.CalfCircumferencecmSlider.Position = [165 53 114 3];
            app.CalfCircumferencecmSlider.Value = 27;

            % Create EditField_h
            app.EditField_h = uieditfield(app.PleaseenterusermeasurementsPanel, 'numeric');
            app.EditField_h.ValueChangedFcn = createCallbackFcn(app, @heightTextValueChanged, true);
            app.EditField_h.Position = [284 198 65 22];
            app.EditField_h.Value = 100;

            % Create EditField_w
            app.EditField_w = uieditfield(app.PleaseenterusermeasurementsPanel, 'numeric');
            app.EditField_w.ValueChangedFcn = createCallbackFcn(app, @weightTextValueChanged, true);
            app.EditField_w.Position = [284 148 65 22];
            app.EditField_w.Value = 36;

            % Create EditField_t
            app.EditField_t = uieditfield(app.PleaseenterusermeasurementsPanel, 'numeric');
            app.EditField_t.ValueChangedFcn = createCallbackFcn(app, @thighTextValueChanged, true);
            app.EditField_t.Position = [284 95 65 22];
            app.EditField_t.Value = 33;

            % Create EditField_c
            app.EditField_c = uieditfield(app.PleaseenterusermeasurementsPanel, 'numeric');
            app.EditField_c.ValueChangedFcn = createCallbackFcn(app, @calfTextValueChanged, true);
            app.EditField_c.Position = [284 43 65 22];
            app.EditField_c.Value = 27;

            % Create BUILDButton
            app.BUILDButton = uibutton(app.UIFigure, 'push');
            app.BUILDButton.ButtonPushedFcn = createCallbackFcn(app, @BUILDButtonPushed, true);
            app.BUILDButton.BackgroundColor = [0.0431 0.1686 0.2314];
            app.BUILDButton.FontColor = [0.9569 0.9569 0.9765];
            app.BUILDButton.Position = [18 13 179 39];
            app.BUILDButton.Text = 'BUILD';

            % Create ExitDesignerButton
            app.ExitDesignerButton = uibutton(app.UIFigure, 'push');
            app.ExitDesignerButton.ButtonPushedFcn = createCallbackFcn(app, @ExitButtonPushed, true);
            app.ExitDesignerButton.BackgroundColor = [0.0431 0.1686 0.2314];
            app.ExitDesignerButton.FontAngle = 'italic';
            app.ExitDesignerButton.FontColor = [0.9569 0.9569 0.9765];
            app.ExitDesignerButton.Position = [213 13 165 39];
            app.ExitDesignerButton.Text = 'Exit Designer';

            % Create YoudeservetostepintocomfortLabel
            app.YoudeservetostepintocomfortLabel = uilabel(app.UIFigure);
            app.YoudeservetostepintocomfortLabel.BackgroundColor = [0.9608 0.9608 0.9804];
            app.YoudeservetostepintocomfortLabel.HorizontalAlignment = 'center';
            app.YoudeservetostepintocomfortLabel.FontName = 'PingFang TC';
            app.YoudeservetostepintocomfortLabel.FontSize = 14;
            app.YoudeservetostepintocomfortLabel.FontWeight = 'bold';
            app.YoudeservetostepintocomfortLabel.FontAngle = 'italic';
            app.YoudeservetostepintocomfortLabel.FontColor = [0.149 0.149 0.149];
            app.YoudeservetostepintocomfortLabel.Position = [405 13 398 39];
            app.YoudeservetostepintocomfortLabel.Text = 'You deserve to step into comfort';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = GUI_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end