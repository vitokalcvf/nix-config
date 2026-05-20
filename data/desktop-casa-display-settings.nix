{
  outputs = {
    "DP-5" = {
      mode = "1920x1080@180.003";
      position = _: {
        props = {
          x = 1920;
          y = 901;
        };
      };
      scale = 1.0;
      transform = "normal";
    };

    "HDMI-A-2" = {
      mode = "1920x1080@100.001";
      position = _: {
        props = {
          x = 840;
          y = 466;
        };
      };
      scale = 1.0;
      transform = "90";
    };
  };
}
