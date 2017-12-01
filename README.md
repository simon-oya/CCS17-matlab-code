# DISCRETE SYNTHETIC EXPERIMENT

In this experiment, we evaluate the performance of Shokri's optimal mechanism, ExPost mechanism and the Coin mechanism, in a synthetic discrete scenario. The map is a 5x5 grid of locations with a label assigned to each one. We measure quality loss as the average loss using the Euclidean distance, and measure privacy as:
1. The average adversary error using the Euclidean distance.
2. The average adversary error using the semantic distance.
3. The conditional entropy.

## Main variables used:
- Number of locations or Points of Interest (`N`)
- Matrix of locations (`X`): this is a Nx2 matrix that contains the possible locations of the users. Each row of the matrix contains the Cartesian coordinates of a location.
- Input prior (`priorX`): this is a Nx1 column vector containing the probability mass function (prior) of the users in the location defined in X. For this experiment, we assume it is uniform.
- Distance matrices (`DP`, `DQ`): this is a NxN matrix whose (j,i)-th element is the distance between the i-th input location and the j-th output location (in this experiment, the input and output alphabet of locations is the same, so this matrix is symmetric). Depending on the type of distance metric we use, we get a different matrix. In this experiment, we use DQ to compute the average loss, so we define it using the Euclidean distance. We use DP to compute Shokri's optimal mechanism when privacy is measured as the average semantic distance, so we define it using this semantic distance.
- Mechanism (`f`): we store the mechanism in a NxN left stochastic matrix whose (j,i)-th element is the probability of choosing the j-th output location when the user is in the i-th input location.

## Description of the files:
Main scripts:
- `s01_evaluate_synthetic.m`: This file runs the experiment and saves the results in RESULTS_EVALUATE.mat.
- `s01_plot_results.m`: This file loads the results in RESULTS_EVALUATE.mat and plots them as in the paper.
Functions:
- `get_distance_matrix.m`: This function computes a distance matrix given a type of distance (e.g., Euclidean or semantic) and the input and output alphabets.
- `get_mechanism.m`: Computes the mechanism matrix (f). It can call other functions:
> - `get_mechanism_expost.m`: When we want to get the ExPost mechanism.
> - `get_optimal_mechanism_Shokri.m`: When we want to get Shokri's optimal mechanism (either by using the simplex or the interior-point algorithm).
- `compute_metrics.m`: it computes the privacy and quality loss metrics given a mechanism and other parameters.
