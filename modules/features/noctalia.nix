{ self, inputs, ...}: {
        
    perSystem = { pkgs, ... }: {
        
        packages.myNoctalia = inputs.wrapper-modules.wrappers.noctalia-shell.wrap {
            inherit pkgs;
            # returned object is already the settings object so no 
            # further indexing needed
            settings = (builtins.fromJSON(builtins.readFile ./noctalia.json));
        };
    };

}
