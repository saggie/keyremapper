using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Windows.Forms;

public class HotKeyManager : Form
{
    [DllImport("user32.dll")]
    private extern static int RegisterHotKey(IntPtr hWnd, int id, int fsModifiers, Keys vk);

    [DllImport("user32.dll")]
    private extern static int UnregisterHotKey(IntPtr hWnd, int id);

    private List<HotKeyAndActionBinding> hotKeyAndActionBindings = new List<HotKeyAndActionBinding>();
    private class HotKeyAndActionBinding
    {
        public int modKey;
        public Keys key;
        public int hotKeyId;
        public Action<string> action;
        public string actionArgument;
        public override string ToString()
        {
            return string.Format(
                "{{modKey={0}, key={1}, hotKeyId={2}, action={3}, actionArgument={4}}}",
                modKey, key, hotKeyId, action, actionArgument
            );
        }
    }

    public HotKeyManager()
    {
        this.WindowState = System.Windows.Forms.FormWindowState.Minimized;
        this.ShowInTaskbar = false;
    }

    private static int idIndex = 0x0000;

    public void RegisterHotKeyAndItsAction(int modKey, Keys key,
                                           Action<string> action, string actionArgument)
    {
        while (idIndex <= 0xbfff)
        {
            if (RegisterHotKey(this.Handle, idIndex, modKey, key) != 0)
            {
                var binding = new HotKeyAndActionBinding();
                binding.modKey = modKey;
                binding.key = key;
                binding.hotKeyId = idIndex++;
                binding.action = action;
                binding.actionArgument = actionArgument;
                hotKeyAndActionBindings.Add(binding);
                break;
            }
            idIndex++;
        }
    }

    public string GetBindingsInformation()
    {
        var bindingListInString = hotKeyAndActionBindings.Select(b => b.ToString()).ToList();
        return "[" + string.Join(", ", bindingListInString) + "]";
    }

    private const int WM_HOTKEY = 0x0312;

    protected override void WndProc(ref Message message)
    {
        base.WndProc(ref message);

        if (message.Msg == WM_HOTKEY)
        {
            foreach (var eachBinding in hotKeyAndActionBindings)
            {
                if ((int)message.WParam == eachBinding.hotKeyId)
                {
                    eachBinding.action(eachBinding.actionArgument);
                }
            }
        }
    }

    protected override void Dispose(bool disposing)
    {
        // Unregister all HotKeys
        hotKeyAndActionBindings.ForEach(binding => UnregisterHotKey(this.Handle, binding.hotKeyId));

        base.Dispose(disposing);
    }
}
