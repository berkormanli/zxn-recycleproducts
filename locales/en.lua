local Translations = {
    notify = {
        RecycledSomeItems = "Thanks for recycling!",
    },
    info = {
        BlipName = "Recycle Products",
        SellItems = "Sell Items",
    },
    menuInfo = {
        SellHeader = "Recycle Point",
        TotalSellPrice = "Total sell price: $%{value}",
        CloseMenu = "⬅ Close Menu",
    }
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})