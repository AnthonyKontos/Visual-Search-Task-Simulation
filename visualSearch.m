function visualSearch(participant_number)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%Experiment%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Screen('Preference', 'SkipSyncTests', 1);

%load experiment settings
searchSettings;

%set screen settings
[w, rect] = Screen('OpenWindow', 1, backgroundColor, [], [], []);
W=rect(RectRight); % screen width
H=rect(RectBottom); % screen height
Screen(w,'FillRect', backgroundColor);
Screen('Flip', w);

HideCursor; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%Setup Trials%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%randomly setup trials so that for approx. x amount of them there is no
%target present
targetpresent_im = zeros(1, trial_amount);
targetpresent_im(1:deception_trials) = 1;

%randomize the trials
targetpresent_im = (Shuffle(targetpresent_im))+1;

%Set up the data output file
outputfile = fopen([results_path '/results_' num2str(participant_number) '.txt'],'a');
fprintf(outputfile, 'Subject\t Trial\t Correct\t Input\t RT\n');

%hit y for stimulus present hit n for stimulus not present
responseKeys = ['y', 'n'];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%Commence Trials%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%text position
inst_horzpos=50;
top_vertpos=100;
inst_vertpos=30;
inst_color=80;

%initialize datasets
RT_data = zeros(1, trial_amount);

%hits
H_Data = zeros(1, trial_amount);
hits = 0;
H_Rate = 0;

%false alarms
FA_Data = zeros(1, trial_amount);
fas = 0;
FA_Rate = 0;

%misses and correc rejections
ms = 0;
M_Rate = 0;
crs = 0;
CR_Rate = 0;

%start screen w/instructions
Screen('DrawText',w,'Identify which like-colored rectangle is in the incorrect orientation -- the target stimlus', inst_horzpos, top_vertpos+inst_vertpos, inst_color);
Screen('DrawText',w,'Press Y if the target stimulus is present', inst_horzpos, top_vertpos+inst_vertpos*2, inst_color);
Screen('DrawText',w,'Press N if the target stimulus is not present', inst_horzpos, top_vertpos+inst_vertpos*3, inst_color);
Screen('DrawText',w,'Press Q to quit any time after begginning the experiment', inst_horzpos, top_vertpos+inst_vertpos*4, inst_color);
Screen('DrawText',w,'Press Z to begin the experiment! You have 10 seconds to respond to each trial', inst_horzpos, top_vertpos+inst_vertpos*5, inst_color);
Screen('Flip',w)

%check for begin response
while 1
    [keyIsDown,secs,keyCode] = KbCheck;
    if keyCode(KbName('z'))==1
        break
    end
end

try
    %start trials
    for n = 1:length(targetpresent_im)

        %determine whether to select target present or target absent visual
        %search image depending on trial order
        if targetpresent_im(n)==2
            imagedir = dir(fullfile(absent_img_path, '\*.png'));
        else
            imagedir = dir(fullfile(present_img_path, '\*.png'));
        end

        %select a random image from the corresponding folder
        randnumber = randi([1 size(imagedir,1)]);
        randomimg = fullfile(imagedir(randnumber).folder, imagedir(randnumber).name);
        displayimage = imread(randomimg);

        %create the visual search display
        show_image = Screen('MakeTexture', w, displayimage);

        %center the image
        img_size = size(displayimage);
        imgposition = [(W-img_size(2))/2 (H-img_size(1))/2 (W+img_size(2))/2 (H+img_size(1))/2];

        %blank screen
        Screen(w, 'FillRect', backgroundColor);
        Screen('Flip', w, 0);

        %show the visual search image
        Screen(w, 'FillRect', backgroundColor);
        Screen('DrawTexture', w, show_image, [], imgposition);
        startTime = Screen('Flip', w); 

        %initialize RT score and response 
        rt = 0;
        resp = 0;

        %retrieve key response (must respond within time specified)
        while GetSecs - startTime < waitTime
            [keyIsDown,secs,keyCode] = KbCheck;
            response_time = GetSecs;
            key_pressed = find(keyCode);

            %q key quits the experiment
            if keyCode(KbName('q')) == 1
                close all
                sca
                return;
            end

            %check for other response keys
            if ~isempty(key_pressed)
                for i = 1:length(responseKeys)
                    if KbName(responseKeys(i)) == key_pressed(1)
                        resp = responseKeys(i);
                        rt = response_time - startTime;
                    end
                    
                    %compile reaction time data
                    RT_data(n) = rt;

                    %record whether hit or false alarm
                    if resp == 'y' && targetpresent_im(n) == 1
                        hits = hits + 1;
                        
                        H_Data(n) = hits./(hits + ms);
                        FA_Data(n) = fas./(fas + crs);
                        break
               
                    elseif resp == 'y' && targetpresent_im(n) == 2
                        fas = fas + 1;
                        
                        H_Data(n) = hits./(hits+ms);
                        FA_Data(n) = fas./(fas + crs);
                        break
                        
                    elseif resp == 'n' && targetpresent_im(n) == 2
                        crs = crs + 1;
                        
                        H_Data(n) = hits./(hits+ms);
                        FA_Data(n) = fas./(fas + crs);
                        break
                        
                    elseif resp == 'n' && targetpresent_im(n) == 1
                        ms = ms + 1;
                        
                        H_Data(n) = hits./(hits+ms);
                        FA_Data(n) = fas./(fas + crs);
                        break
                        
                    end
                    
                   
                end
            end
            
            %break out of loop once response is received 
            if rt > 0
                break;
            end
        end
  
        %blank screen
        Screen(w, 'FillRect', backgroundColor);
        Screen('Flip', w, 1, 0);

        %Save results to file
        fprintf(outputfile, '%d\t %d\t %s\t %s\t %f\n', participant_number, n, responseKeys(targetpresent_im(n)), resp, rt);

        %clear window
        Screen(show_image,'Close');
        
        %wait 1 second before next trial
        WaitSecs(1);    
    end
    
    %compute mean and max reaction time
    RT_mean=nanmean(RT_data);
    RT_maximum=max(RT_data);
    
    %compute false alarm rate and hit rate
    H_Rate = hits./trial_amount;
    FA_Rate = fas./trial_amount;
    
    %compute miss and correct rejection rate
    M_Rate = ms./trial_amount;
    CR_Rate = crs./trial_amount;
    
    %display mean and max reaction time
    disp('Mean Reaction Time:')
    disp(RT_mean)
    
    disp('Max Reaction Time:')
    disp(RT_maximum)
    
    %plot reaction time
    figure(1)
    plot(1:trial_amount, RT_data)
    
    title('Reaction time versus Time')
    xlabel('Trial number')
    ylabel('Reaction time (seconds)');


    %compute dp
    dprime = norminv(H_Rate)-norminv(FA_Rate);

    %compute c
    c = -0.5.*(norminv(H_Rate)+norminv(FA_Rate));
   
%--------------------plot false alarm rate against hit rate and ROC------------------------% 
 
    FA_Data = FA_Data(:);
    H_Data = H_Data(:);
    
    % Calculating the threshold values between the data points
    exp_data = unique(sort([FA_Data; H_Data]));          % Sorted data points
    exp_data(isnan(exp_data)) = [];                 % Delete NaN values
    diff_data = diff(exp_data);                      % Difference between consecutive points
    diff_data(length(diff_data)+1,1) = diff_data(length(diff_data));% Last point
    thres(1,1) = exp_data(1) - diff_data(1);                 % First point
    thres(2:length(exp_data)+1,1) = exp_data + diff_data./2;   % Threshold values
        
    % Calculating the sensibility and specificity of each threshold
    curve = zeros(size(thres,1),2);
    distance = zeros(size(thres,1),1);
    for id_t = 1:1:length(thres)
        TP = length(find(H_Data >= thres(id_t)));    % True positives
        FP = length(find(FA_Data >= thres(id_t)));    % False positives
        FN = length(find(H_Data < thres(id_t)));     % False negatives
        TN = length(find(FA_Data < thres(id_t)));     % True negatives
        
        curve(id_t,1) = TP/(TP + FN);   % Sensitivity
        curve(id_t,2) = TN/(TN + FP);	% Specificity
        
        % Distance between each point and the optimum point (0,1)
        distance(id_t)= sqrt((1-curve(id_t,1))^2+(curve(id_t,2)-1)^2);
    end
    
    % Optimum threshold and parameters
    [~, opt] = min(distance);   
    
    % Output parameters
    threshold = thres(opt);               % Optimum threshold position
    AROC = abs(trapz(1-curve(:,2),curve(:,1))); % Area under curve
    accuracy = (hits + crs)/(hits+crs+fas+ms);     % Accuracyy 
    
    % Plotting AUC
    figure(2)
    fill_color = [11/255, 208/255, 217/255];
    fill([1-curve(:,2); 1],[curve(:,1); 0], fill_color,'FaceAlpha',0.5);
    hold on; plot(1-curve(:,2), curve(:,1), '-b', 'LineWidth', 2);
    hold on; plot(1-curve(opt,2), curve(opt,1), 'or', 'MarkerSize', 10);
    hold on; plot(1-curve(opt,2), curve(opt,1), 'xr', 'MarkerSize', 12);
    hold off; axis square; grid on; xlabel('False Alarm rate'); ylabel('Hit rate');
    title(['AROC = ' num2str(AROC)]);
    
    % Log screen parameters if required
    fprintf('\nPARAMETERS\n');

    fprintf('H rate: %4.3f\nFA rate: %4.3f\ndprime: %4.3f\nc: %4.3f\nAROC: %.4f\nAccuracy: %.4f\n', H_Rate, FA_Rate, dprime, c, AROC, accuracy);
    fprintf(' \n');

    %close file
    fclose(outputfile);

%catch errors
catch
    ShowCursor;
    rethrow(lasterror);n
    Screen('CloseAll');
end

%close window
sca;
return

end