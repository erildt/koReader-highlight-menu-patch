local ReaderHighlight = require("apps/reader/modules/readerhighlight")
local _ = require("gettext")
local C_ = _.pgettext
local UIManager = require("ui/uimanager")
local util = require("util")
local Event = require("ui/event")
local Notification = require("ui/widget/notification")
local logger = require("logger")
local Device = require("device")

-- Store the original function to call it later if needed
local orig_init = ReaderHighlight.init

function ReaderHighlight:init()
    -- Call the original function first (if you want to preserve its behavior)
    orig_init(self)
    
    -- Add your custom code here
    self._highlight_buttons = {
        -- highlight and add_note are for the document itself,
        -- so we put them first.
        ["01_select"] = function(this)
            return {
                text = _("Select"),
                enabled = this.hold_pos ~= nil,
                callback = function()
                    this:startSelection()
                    this:onClose()
                end,
            }
        end,
        ["02_highlight"] = function(this)
            return {
                text = _("Highlight"),
                enabled = this.hold_pos ~= nil,
                callback = function()
                    this:saveHighlightFormatted(true,"lighten",self.view.highlight.saved_color)
                    this:onClose()
                end,
            }
        end,
		["03_underline"] = function(this)
            return {
                text = _("Underline"),
                enabled = this.hold_pos ~= nil,
                callback = function()
                    this:saveHighlightFormatted(true,"underscore",self.view.highlight.saved_color)
                    this:onClose()
                end,
            }
        end,
        ["04_copy"] = function(this)
            return {
                text = C_("Text", "Copy"),
                enabled = Device:hasClipboard(),
                callback = function()
                    Device.input.setClipboardText(util.cleanupSelectedText(this.selected_text.text))
                    this:onClose()
                    UIManager:show(Notification:new{
                        text = _("Selection copied to clipboard."),
                    })
                end,
            }
        end,
        ["05_add_note"] = function(this)
            return {
                text = _("Add note"),
                enabled = this.hold_pos ~= nil,
                callback = function()
                    this:addNote()
                    this:onClose()
                end,
            }
        end,
        ["06_dictionary"] = function(this, index)
            return {
                text = _("Dictionary"),
                callback = function()
                    this:lookupDict(index)
                    -- We don't call this:onClose(), same reason as above
                end,
            }
        end,
        ["07_translate"] = function(this, index)
            return {
                text = _("Translate"),
                callback = function()
                    this:translate(index)
                    -- We don't call this:onClose(), so one can still see
                    -- the highlighted text when moving the translated
                    -- text window, and also if NetworkMgr:promptWifiOn()
                    -- is needed, so the user can just tap again on this
                    -- button and does not need to select the text again.
                end,
            }
        end,
        -- buttons 08-11 are conditional ones, so the number of buttons can be even or odd
        -- let the Search button be the last, occasionally narrow or wide, less confusing
        ["12_search"] = function(this)
            return {
                text = _("Search"),
                callback = function()
                    this:onHighlightSearch()
                    -- We don't call this:onClose(), crengine will highlight
                    -- search matches on the current page, and self:clear()
                    -- would redraw and remove crengine native highlights
                end,
            }
        end,
	}
end

function ReaderHighlight:saveHighlightFormatted(extend_to_sentence,hlStyle,hlColor)
    logger.dbg("save highlight")
    if self.hold_pos and not self.selected_text then
        self:highlightFromHoldPos()
    end
    if self.selected_text and self.selected_text.pos0 and self.selected_text.pos1 then
        local pg_or_xp
        if self.ui.rolling then
            if extend_to_sentence then
                local extended_text = self.ui.document:extendXPointersToSentenceSegment(self.selected_text.pos0, self.selected_text.pos1)
                if extended_text then
                    self.selected_text = extended_text
                end
            end
            pg_or_xp = self.selected_text.pos0
        else
            pg_or_xp = self.selected_text.pos0.page
        end
        local item = {
            page = self.ui.paging and self.selected_text.pos0.page or self.selected_text.pos0,
            pos0 = self.selected_text.pos0,
            pos1 = self.selected_text.pos1,
            text = util.cleanupSelectedText(self.selected_text.text),
            drawer = hlStyle,
            color = hlColor,
            --chapter = self.ui.toc:getTocTitleByPage(pg_or_xp),
			chapter = table.concat(self.ui.toc:getFullTocTitleByPage(pg_or_xp), " ▸ "),
        }
        if self.ui.paging then
            item.pboxes = self.selected_text.pboxes
            item.ext = self.selected_text.ext
            self:writePdfAnnotation("save", item)
        end
        local index = self.ui.annotation:addItem(item)
        self.view.footer:maybeUpdateFooter()
        self.ui:handleEvent(Event:new("AnnotationsModified", { item, nb_highlights_added = 1, index_modified = index }))
        return index
    end
end
