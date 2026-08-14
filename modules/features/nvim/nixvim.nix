{ self, inputs, ... }: {
 
  perSystem = {pkgs, system, ...}: {
      packages.nixvimConf = inputs.nixvim.legacyPackages.${system}.makeNixvimWithModule{
	inherit pkgs;
	module = import ./_nixvim-config.nix;
      };
  };


  flake.nixosModules.nixvim = { pkgs, ... }: {
    
      environment.systemPackages = [self.packages.${pkgs.stdenv.hostPlatform.system}.nixvimConf];
};
}
