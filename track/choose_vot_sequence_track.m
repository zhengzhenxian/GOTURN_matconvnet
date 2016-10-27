function choose_vot_sequence_track(net_file,base_path,gpu_id,show_visualization)
if ispc()
    if nargin < 1, net_file = '../model/GOTURN_net.mat'; end
    if nargin < 2, base_path = 'E:\data\vot2015/'; end
    if nargin < 3, gpu_id = [2]; end
    if nargin < 4, show_visualization = 1; end
else
    if nargin < 1, net_file = '../model/GOTURN_net.mat'; end
    if nargin < 2, base_path = '../data/VOT14/'; end
    if nargin < 3, gpu_id = []; end
    if nargin < 4, show_visualization = 1; end
end


dirs = dir(base_path);
videos = {dirs.name};
videos(strcmp('.', videos) | strcmp('..', videos)| ~[dirs.isdir]) = [];

v = listdlg('ListString',videos, 'Name','Choose video', 'SelectionMode','single');
if isempty(v),return; end
video = videos{v};
 
if exist(net_file,'file')
    net = dagnn.DagNN.loadobj(load(net_file));
else
    error('No net to load!!!!');
end

if numel(gpu_id)>0    %TODO
%    gpuDevice(gpu_id) ;
   net.move('gpu') ; 
end
net.mode = 'test';

[img_files, ground_truth] = load_video_info_vot(base_path, video);
[result, time] = tracker(img_files, ground_truth, net, gpu_id, show_visualization);
fprintf('Video: %d , fps:%3.3f\n',v,size(result,1)/time);

end %%function

