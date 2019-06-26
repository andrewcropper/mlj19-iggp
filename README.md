Code and experimental data for the paper:

A. Cropper, R. Evans, and M. Law. [Inductive general game playing](http://andrewcropper.com/pubs/mlj19-iggp.pdf). Machine learning journal. Accepted.

This repository consists of the code used to run the experiment and three zip files:

- data.zip, which when unzipped puts the raw GGP data in the folder 'data'
- programs.zip, which when unzipped puts the learned programs in the folder 'programs/$system'
- results.zip, which when unzipped puts the test results in the folder 'results/$system'

Therefore, you first need to unzip those three files.

The repository does not contain the parsed data (which should go in the folder exp/$system) because the data is very large. Therefore, to reproduce the experimental results, you first need to reparse the data by running 'python runner.py parse'. After this step the experimental results can be reproduced as follows:

1. To reproduce the results run 'python runner.py results'
2. To rerun the testing step, run 'python runner.py test'
3. To rerun the learning step, run 'python runner.py learn'

The above commands will run for all systems. You need to modify the runner.py file to run the experiments for a specific system.