In order to achieve the required, I firstly used that file :
- 'features.txt': List of all features.
and selected only the features that were needed.

Secondly I had to merge the the train and test datasets using those four files:

- 'train/X_train.txt': Training set.
- 'train/y_train.txt': Training labels.
- 'test/X_test.txt': Test set.
- 'test/y_test.txt': Test labels.

Then in order to have readable activity names I had to use the factor function on this file that was extracted earlier:
- 'activity_labels.txt': Links the class labels with their activity name.

Evevntually a copy of this tidy data was created by the name "TidyData.txt"
