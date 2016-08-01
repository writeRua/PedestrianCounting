This branch is to train gaussian model.
Most of the code is for vidf dataset. If you want to deal with other datasets, some details of the code should be changed.


feature_extraction_vidf.m:
    To extract features of dataset vidf.(How many people in each frame)
    To run it, you should first get the code in branch FeatureExtraction.
    Please set the parameters in "basic settings" by yourself.

gather_features.m:
    To change the features in the form that FeatureExtraction_dataset.m or FeatureExtraction_file.m give out,to a matrix.
    (Note: the result of feature_extraction_vidf.m also need to be dealt with by this code. It's done in train_Gaussian.m)
        features: The result of FeatureExtraction_dataset.m or FeatureExtraction_file.m. Or the result of feature_extraction_vidf.m
        feature_kind: The kinds of features you want to gather. It should be a cell of strings. It has default value as in FeatureExtraction.m
        range: A vector. Maybe you don't want to use the whole dataset, and you can use this parameter to control. It has default value=[1:length(features)]


vidf_groundtruth.m:
    To get the groundtruth of dataset vidf.
    To run it, you should first download the gt(groundtruth) of vidf
    Please set the parameters in "basic settings" by yourself.

error_rate.m:
    To compute mae and mse between groundtruth and prediction.

train_Gaussian.m
    To train Gaussian for dataset vidf.
    To run it, you should first extract features of vidf using feature_extraction_vidf.m
        (You can also extract features in other ways. But notice that you may need to delete the code in "to gather fatures into a matrix")
    Before run it, you should run vidf_groundtruth.m one time, to get the groundtruth of vidf.
    To run it, GPML library is needed.
    Please set the parameters in "basic settings" by yourself.
    Please set the parameters in "GP parameters" by yourself.