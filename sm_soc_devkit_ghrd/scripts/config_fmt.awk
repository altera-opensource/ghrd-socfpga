BEGIN{
  FS=" "
  config_str = "";
  OUTPUT_FILE = output;
}{
  for (i = 1; i <= NF; i++) {
    if (match($i, /(.+)=(.+)/, var)) {
      config_str = config_str "" sprintf("%-30s=%5s%s\n", var[1], " ", var[2]);
    }
  }
}END{
    print config_str > OUTPUT_FILE
}

