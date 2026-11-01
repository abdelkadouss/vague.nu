# Retrieve the theme settings
export def main [ ] {
  const color_palette = {
    black: "#141415"
    shadow: "#1c1c24"
    graphite: "#252530"
    onyx: "#333738"
    muted: "#606079"
    gray: "#878787"
    white: "#cdcdcd"
    yellow: "#f3be7c"
    amber: "#e8b589"
    gold: "#e0a363"
    peach: "#c48282"
    red: "#d8647e"
    storm: "#405065"
    lilac: "#c3c3d5"
    cyan: "#aeaed1"
    magenta: "#bb9dbd"
    aqua: "#b4d4cf"
    lavender: "#90a0b5"
    teal: "#9bb4bc"
    blue: "#6e94b2"
    iris: "#7e98e8"
    green: "#7fa563"
  }

  return {
    separator: $color_palette.muted
    leading_trailing_space_bg: { attr: "n" }
    header: { fg: $color_palette.blue attr: "b" }
    empty: $color_palette.lavender
    bool: $color_palette.iris
    int: $color_palette.gold
    duration: $color_palette.white
    filesize: { |e|
      if $e < 1mb {
        $color_palette.green
      } else if $e < 100mb {
        $color_palette.yellow
      } else if $e < 500mb {
        $color_palette.amber
      } else if $e < 800mb {
        $color_palette.peach
      } else if $e > 800mb {
        $color_palette.red
      }
    }
    datetime: { ||
      (date now) - $in | if $in < 1hr {
        $color_palette.green
      } else if $in < 1day {
        $color_palette.yellow
      } else if $in < 3day {
        $color_palette.amber
      } else if $in < 1wk {
        $color_palette.peach
      } else if $in > 1wk {
        $color_palette.red
      }
    }
    range: $color_palette.white
    float: $color_palette.white
    string: $color_palette.white
    nothing: $color_palette.white
    binary: $color_palette.white
    'cell-path': $color_palette.white
    row_index: { fg: $color_palette.magenta attr: "b" }
    record: $color_palette.white
    list: $color_palette.white
    block: $color_palette.white
    hints: $color_palette.gray

    search_result: { fg: $color_palette.red bg: $color_palette.white }

    shape_and: { fg: $color_palette.magenta attr: "b" }
    shape_binary: { fg: $color_palette.magenta attr: "b" }
    shape_block: { fg: $color_palette.blue attr: "b" }
    shape_bool: $color_palette.teal
    shape_custom: $color_palette.green
    shape_datetime: { fg: $color_palette.teal attr: "b" }
    shape_directory: $color_palette.teal
    shape_external: $color_palette.teal
    shape_externalarg: { fg: $color_palette.green attr: "b" }
    shape_filepath: $color_palette.teal
    shape_flag: { fg: $color_palette.blue attr: "b" }
    shape_float: { fg: $color_palette.magenta attr: "b" }
    shape_garbage: { fg: $color_palette.white bg: $color_palette.red attr: "b" }
    shape_globpattern: { fg: $color_palette.teal attr: "b" }
    shape_int: { fg: $color_palette.magenta attr: "b" }
    shape_internalcall: { fg: $color_palette.teal attr: "b" }
    shape_list: { fg: $color_palette.teal attr: "b" }
    shape_literal: $color_palette.blue
    shape_match_pattern: $color_palette.green
    shape_matching_brackets: { attr: "u" }
    shape_nothing: $color_palette.teal
    shape_operator: $color_palette.yellow
    shape_or: { fg: $color_palette.magenta attr: "b" }
    shape_pipe: { fg: $color_palette.magenta attr: "b" }
    shape_range: { fg: $color_palette.yellow attr: "b" }
    shape_record: { fg: $color_palette.teal attr: "b" }
    shape_redirection: { fg: $color_palette.magenta attr: "b" }
    shape_signature: { fg: $color_palette.green attr: "b" }
    shape_string: $color_palette.green
    shape_string_interpolation: { fg: $color_palette.teal attr: "b" }
    shape_table: { fg: $color_palette.blue attr: "b" }
    shape_variable: $color_palette.magenta

    background: $color_palette.black
    foreground: $color_palette.white
    cursor: $color_palette.iris
  }
}

# Update the Nushell configuration
export def --env "set color_config" [ ] {
  $env.config.color_config = (main)
}

# Update terminal colors base on the $env.config.color_config env var
export def "update terminal" [ ] {
  let theme = ($env.config.color_config) # you can use main here but i make it get the theme from the env becuse i wanna add the ability overwrite the default colors and i expect u to use that thing afver the `set color_config` function.

  # Set terminal colors
  let osc_screen_foreground_color = '10;'
  let osc_screen_background_color = '11;'
  let osc_cursor_color = '12;'

  $"
    (ansi --osc $osc_screen_foreground_color)($theme.foreground)(char bel)
    (ansi --osc $osc_screen_background_color)($theme.background)(char bel)
    (ansi --osc $osc_cursor_color)($theme.cursor)(char bel)
    "
  # Line breaks above are just for source readability
  # but create extra whitespace when activating. Collapse
  # to one line and print with no-newline
  | str replace --all "\n" ''
  | print --no-newline $"($in)\r"
}

export module activate {
  export-env {
    set color_config
    update terminal
  }
}

# Activate the theme when sourced
use activate
