$env.config = ($env.config? | default {})
$env.config.hooks = ($env.config.hooks? | default {})
$env.config.hooks.pre_prompt = (
    $env.config.hooks.pre_prompt?
    | default []
    | append {||
        if (which direnv | is-empty) {
            return
        }
        direnv export json
        | from json
        | default {}
        | load-env
    }
)

