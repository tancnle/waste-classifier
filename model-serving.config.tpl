model_config_list {
  config: {
    name: "{{model_name}}"
    base_path: "/models/{{model_name}}/"
    model_platform: "tensorflow"

    model_version_policy {
      specific {
        versions: {{model_version}}
      }
    }

    version_labels {
      key: "{{model_label}}"
      value: {{model_version}}
    }
  }
}
