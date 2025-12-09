{ config, lib, pkgs, ... }:

let
  cuda = pkgs.cudaPackages_13_0;
in
{
  # enable CUDA support in nixpkgs
  nixpkgs.config.cudaSupport = true;

  environment.systemPackages = [
    cuda.cudatoolkit
    cuda.cudnn
    cuda.tensorrt
  ];

  # CUDA environment variables
  environment.sessionVariables = {
    CUDA_PATH = "${cuda.cudatoolkit}";
    CUDNN_PATH = "${cuda.cudnn}";
    TENSORRT_PATH = "${cuda.tensorrt}";
  };
}
