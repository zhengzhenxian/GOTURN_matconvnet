function [img_files, ground_truth] = load_video_info_otb(base_path, video)

if numel(video) >= 2 && video(end-1) == '-' && ~isnan(str2double(video(end))),
    suffix = ['.' video(end)];  %remember the suffix
    video = video(1:end-2);  %remove it from the video name
else
    suffix = '';
end

video_path = fullfile(base_path,video);

filename = fullfile(video_path,['groundtruth_rect' suffix '.txt']);
ground_truth = dlmread(filename);
ground_truth = [ground_truth(:,1),ground_truth(:,2),...
    ground_truth(:,1),ground_truth(:,2)+ground_truth(:,4),...
    ground_truth(:,1)+ground_truth(:,3),ground_truth(:,2)+ground_truth(:,4),...
    ground_truth(:,1)+ground_truth(:,3),ground_truth(:,2)];

%set initial position and size
if strcmp(video,'Tiger1')
    ground_truth(1:5,:) = [];
end


frames = {'David', 300, 770;
    'Football1', 1, 74;
    'Freeman3', 1, 460;
    'Freeman4', 1, 283;
    'Tiger1',6,354;
    'Diving',1,215};

idx = find(strcmpi(video, frames(:,1)));

img_path = fullfile(video_path,'img');
if isempty(idx),
    %general case, just list all images
    img_files = dir(fullfile(img_path,'*.png'));
    if isempty(img_files),
        img_files = dir(fullfile(img_path,'*.jpg'));
        assert(~isempty(img_files), 'No image files to load.')
    end
    img_files = sort({img_files.name});
else
    %list specified frames. try png first, then jpg.
    if exist(fullfile(img_path,sprintf('%04i.png',frames{idx,2})), 'file'),
        img_files = num2str((frames{idx,2} : frames{idx,3})', '%04i.png');
    elseif exist(fullfile(img_path,sprintf('%04i.jpg', frames{idx,2})), 'file'),
        img_files = num2str((frames{idx,2} : frames{idx,3})', '%04i.jpg');
    else
        error('No image files to load.')
    end
    
    img_files = cellstr(img_files);
end
img_files = fullfile(img_path,img_files);
end

