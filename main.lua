local STEPS = 16

local channels = {
  "BD",
  "SN",
  "CH",
  "OH"
}

local function show_status(message)
  renoise.app():show_status(message)
  print(message)
end

function showsequencer()
  -- todo: get pattern from current track

  local vb = renoise.ViewBuilder()

  local dialog_content = vb:column {
    margin = renoise.ViewBuilder.DEFAULT_CONTROL_MARGIN
  }

  renoise.song().selected_track.visible_note_columns = #channels

  for channel = 1, #channels do
    local row = vb:row {}
    row:add_child(vb:text {
      text = channels[channel],
      width = 2 * renoise.ViewBuilder.DEFAULT_CONTROL_HEIGHT
    })
    for step = 1, STEPS do
      local step4 = (step-1) % 4 == 0
      local stepon =

      -- this dowsn't work, but it'll be simlar to get note in current position
      -- renoise.song().selected_phrase:line(step * 4).note_column(channel)



      local color
      if stepon then
        if step4 then
          color = {0x33,0,0}
        else
          color = {0x66,0,0}
        end
      else
        if step4 then
          color = {0x33 , 0x33 , 0x33}
        else
          color = {0,0,0}
        end
      end

      row:add_child(vb:button {
        id = channel .. "_" .. step,
        color = color,
        notifier = function()
          show_status(("channel: %d, step: %d"):format(channel, step))
          stepon = not stepon
          if stepon then
            if step4 then
              vb.views[channel .. "_" .. step].color = {0x33,0,0}
            else
              vb.views[channel .. "_" .. step].color = {0x66,0,0}
            end
          else
            if step4 then
              vb.views[channel .. "_" .. step].color = {0x33 , 0x33 , 0x33}
            else
              vb.views[channel .. "_" .. step].color = {0,0,0}
            end
          end
        end
      })
    end
    dialog_content:add_child(row)
  end

  renoise.app():show_custom_dialog("Simple Sequencer", dialog_content)
end

renoise.tool():add_menu_entry {
  name = "Main Menu:Tools:Simple Sequencer",
  invoke = showsequencer
}