local image = require 'image'

image.setup {
    backend = 'kitty',
    integrations = {
        markdown = {
            enabled = true,
        },
        html = {
            enabled = true,
        },
        css = {
            enabled = true,
        },
    },
    max_width_window_percentage = 100,
    max_height_window_percentage = 100,
    window_overlap_clear_enabled = true,
}
