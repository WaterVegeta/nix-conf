{ self, inputs, ...}: {

	flake.nixosConfigurations.myPc = inputs.nixpkgs.lib.nixosSystem{
		modules = [
			self.nixosModules.myPcConfiguration
		];
	};
}
