{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    python313Packages.numpy
    python313Packages.pandas
    python313Packages.matplotlib
    python313Packages.scipy
    python313Packages.scikit-learn
    python313Packages.jupyterlab
    



    R
    rPackages.ggplot2
    rPackages.dplyr
    

  ];
}

