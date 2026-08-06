{ self, inputs, ...}: {
	flake.nixosConfigurations.myLaptop = inputs.nixpkgs.lib.nixosSystem{
		modules = [
			self.nixosModules.laptopConfig
		];
	};
}
