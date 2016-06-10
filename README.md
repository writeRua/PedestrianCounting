# &#x1F4D9; PedestrianCounting


### getFeatureConsistancy.m

Extract features and temporal, spatial consistancis from one or more directories.

**Input**

`**FeatureName**`: e.g. {Area,Perimeter,PerimeterEdgeOrientation,Ratio,Edge,EdgeOrientation,FractalDim,GLCM}

`path`: roi_path, dmap_path, groundtruth_path, origin_image_dir, foreground_mask_dir

`opt`: isoutput, min_blob, num_frame, gt_boundary_count, gt_nodirection_count, gt_only_roi_count, max_blob_index, frame_index


**Output**

`FrameFeature`: features of each blob {frame_index, blob_id, touch_boundary, direction, ground_truth, *FeatureName*}

`temproal_consistance`

`spacial_consistance`

`max_blob_index`: maximum blob index

### getBlobs.m

Get all blobs of current frame and features of each blob.

### label_blobs

Extract temporal and spatial consistancis from two adjacent frames; Assign index for each blob;

### test.m

a demo which extract blob features and consistancis from 20 directories.
