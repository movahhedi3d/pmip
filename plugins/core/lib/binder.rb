import com.intellij.openapi.actionSystem.ActionManager
import com.intellij.openapi.actionSystem.KeyboardShortcut
import com.intellij.openapi.keymap.KeymapManager
import javax.swing.KeyStroke;

#TODO: consider holding onto all actions and keys - like mount, so they can be cleanly removed

class Binder
  def self.bind(key, action)
    key.sub!('banana', 'ctrl alt shift')
    keymap = KeymapManager.instance.active_keymap

    id = action.name
    action_manager = ActionManager.instance
    action_manager.unregister_action(id)
    keymap.remove_shortcut(id, shortcut(key))
    action_manager.register_action(id, action)
    keymap.add_shortcut(id, shortcut(key))

    #TODO: make constant
    #TODO: fix naming convention
    pmipActionGroup = action_manager.get_action("PMIP::PopupMenu")
    pmipActionGroup.add(action)
    
    puts "- Bound #{id} -> #{key}"
    self
  end

  private

  def self.shortcut(key)
    KeyboardShortcut.new(KeyStroke.get_key_stroke(key), nil)
  end
end

def bind(key, action)
  Binder.bind(key, action)
end

#TODO: make constant
#TODO: add $plugin namespace support
action_manager = ActionManager.instance
pmip_action_group = action_manager.getAction("PMIP::PopupMenu")
pmip_action_group.remove_all