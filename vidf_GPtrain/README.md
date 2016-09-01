This branch is to train gaussian model.
Most of the code is for vidf dataset. If you want to deal with other datasets, some details of the code should be changed.

If you just want to do what I did, please run feature_extraction_vidf.m, vidf_groundtruth.m


================================scripts£º

feature_extraction_vidf.m:
    To extract features of dataset vidf.(How many people in each frame)
    To run it, you should first get the code in branch FeatureExtraction.
    Please set the parameters in "basic settings" by yourself.


vidf_groundtruth.m:
    To get the groundtruth of dataset vidf.
    To run it, you should first download the gt(groundtruth) of vidf
    Please set the parameters in "basic settings" by yourself.

get_blob_train_data.m:
    To get the features of blobs, and the corresponding ground_truth.


train_Gaussian.m
    To train Gaussian for dataset vidf.
    To run it, you should first extract features of vidf using feature_extraction_vidf.m
        (You can also extract features in other ways. But notice that you may need to delete the code in "to gather fatures into a matrix")
    Before run it, you should run vidf_groundtruth.m one time, to get the groundtruth of vidf.
    If you want to use information from blobs, you should first run get_blob_train_data.m
    To run it, GPML library is needed.
    Please set the parameters in "basic settings" by yourself.
    Please set the parameters in "GP parameters" by yourself.




================================functions:

error_rate.m:
    To compute mae and mse between groundtruth and prediction.

gather_features.m:
    To change the features in the form that FeatureExtraction_dataset.m or FeatureExtraction_file.m give out,to a matrix.
    (Note: the result of feature_extraction_vidf.m also need to be dealt with by this code. It's done in train_Gaussian.m)
        features: The result of FeatureExtraction_dataset.m or FeatureExtraction_file.m. Or the result of feature_extraction_vidf.m
        feature_kind: The kinds of features you want to gather. It should be a cell of strings. It has default value as in FeatureExtraction.m
        range: A vector. Maybe you don't want to use the whole dataset, and you can use this parameter to control. It has default value=[1:length(features)]

gather_frame_features.m:
    To change the features in the form that FeatureExtraction.m give out,to a vector.
        features: The result of FeatureExtraction.m
        feature_kind: The kinds of features you want to gather. It should be a cell of strings. It has default value as in FeatureExtraction.m

get_blob_mask.m:    
    To get the mask of blobs in one frame.

predict_by_GP.m:
    To predict how there are many persons in one frame, using the trainded GP model.
        gpm: the trained GP model.
        other parameters are as above.

