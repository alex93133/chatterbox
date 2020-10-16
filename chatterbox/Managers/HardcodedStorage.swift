import Foundation

// Temporary implementation
struct HardcodedStorage {

    static let shared = HardcodedStorage()
    private init() {}

    struct ConversationsListSections {
        let title: String
        var conversations: [ConversationCellModel]
    }

    var sections: [ConversationsListSections] {
        let conversations = HardcodedStorage.shared.conversations

        let onlineSection = ConversationsListSections(title: NSLocalizedString("Online", comment: ""),
                                                      conversations: conversations.filter { $0.isOnline })
        let offlineSection = ConversationsListSections(title: NSLocalizedString("History", comment: ""),
                                                       conversations: conversations.filter { !$0.isOnline })
        let sections       = [onlineSection, offlineSection]
        return sections
    }

    var conversations =  [ConversationCellModel(name: "Вадим Якушенко",
                                                message: "Заедете?",
                                                date: Date().addingTimeInterval(-60),
                                                isOnline: true,
                                                hasUnreadMessages: true),
                          ConversationCellModel(name: "Никита Семенчин",
                                                message: "кетчуп еще",
                                                date: Date().addingTimeInterval(-1000),
                                                isOnline: true,
                                                hasUnreadMessages: true),
                          ConversationCellModel(name: "Вячеслав Чериченко",
                                                message: "мне нужно только еще на заправку заехать",
                                                date: Date().addingTimeInterval(-2000),
                                                isOnline: true,
                                                hasUnreadMessages: true),
                          ConversationCellModel(name: "Андрей Чернов",
                                                message: "скинь пожалуйста",
                                                date: Date().addingTimeInterval(-5000),
                                                isOnline: true,
                                                hasUnreadMessages: true),
                          ConversationCellModel(name: "Дарья Михаль",
                                                message: "что думаешь?",
                                                date: Date().addingTimeInterval(-20000),
                                                isOnline: true,
                                                hasUnreadMessages: false),
                          ConversationCellModel(name: "Папа",
                                                message: "перезвони",
                                                date: Date().addingTimeInterval(-50000),
                                                isOnline: true,
                                                hasUnreadMessages: false),
                          ConversationCellModel(name: "Мама",
                                                message: "спички",
                                                date: Date().addingTimeInterval(-100000),
                                                isOnline: true,
                                                hasUnreadMessages: false),
                          ConversationCellModel(name: "Олег Вараксин",
                                                message: "арбуз бы",
                                                date: Date().addingTimeInterval(-500000),
                                                isOnline: true,
                                                hasUnreadMessages: false),
                          ConversationCellModel(name: "Сестра",
                                                message: "остальное мы купим :D",
                                                date: Date().addingTimeInterval(-1000000),
                                                isOnline: true,
                                                hasUnreadMessages: false),
                          ConversationCellModel(name: "Егор Корешилов",
                                                message: "",
                                                date: Date(),
                                                isOnline: true,
                                                hasUnreadMessages: false),
                          ConversationCellModel(name: "Юлия Буханько",
                                                message: "жарко так на улице так-то",
                                                date: Date().addingTimeInterval(-60),
                                                isOnline: false,
                                                hasUnreadMessages: true),
                          ConversationCellModel(name: "Брат",
                                                message: "купи хлеееееб",
                                                date: Date().addingTimeInterval(-3000),
                                                isOnline: false,
                                                hasUnreadMessages: true),
                          ConversationCellModel(name: "Анатолий Путьмаков",
                                                message: "заедь потом до меня",
                                                date: Date().addingTimeInterval(-10000),
                                                isOnline: false,
                                                hasUnreadMessages: false),
                          ConversationCellModel(name: "Сергей Гнатюк",
                                                message: "вроде ничего не забыл",
                                                date: Date().addingTimeInterval(-40000),
                                                isOnline: false,
                                                hasUnreadMessages: false),
                          ConversationCellModel(name: "Миша",
                                                message: "скорее бы",
                                                date: Date().addingTimeInterval(-80000),
                                                isOnline: false,
                                                hasUnreadMessages: false),
                          ConversationCellModel(name: "Максим Двойников",
                                                message: "нормально?",
                                                date: Date().addingTimeInterval(-100000),
                                                isOnline: false,
                                                hasUnreadMessages: false),
                          ConversationCellModel(name: "Илья Степанов",
                                                message: "завези потом",
                                                date: Date().addingTimeInterval(-5000000),
                                                isOnline: false,
                                                hasUnreadMessages: false),
                          ConversationCellModel(name: "Григорий Данилюк",
                                                message: "ты кстати справку уже сделал на работу?",
                                                date: Date().addingTimeInterval(-10000000),
                                                isOnline: false,
                                                hasUnreadMessages: false),
                          ConversationCellModel(name: "Вова Тарасенков",
                                                message: "ок?",
                                                date: Date().addingTimeInterval(-20000000),
                                                isOnline: false,
                                                hasUnreadMessages: false),
                          ConversationCellModel(name: "Артем Копылов",
                                                message: "вы успеете?",
                                                date: Date().addingTimeInterval(-30000000),
                                                isOnline: false,
                                                hasUnreadMessages: false)]

    func getCellModels(finalMessage: String) -> [MessageCellModel] {
        var defaultMessages = [
            MessageCellModel(text: "Привет!",
                             isIncoming: true),
            MessageCellModel(text: "Привет)",
                             isIncoming: false),
            MessageCellModel(text: "Вы поедете с нами в четверг 😏",
                             isIncoming: true),
            MessageCellModel(text: "А во сколько?",
                             isIncoming: false),
            MessageCellModel(text: "Нууу мы планируем после работы, примерно в 7",
                             isIncoming: true),
            MessageCellModel(text: "Да, погнали",
                             isIncoming: false),
            MessageCellModel(text: "Взять что-то в магазине, мы как раз мимо пятерочки поедем?",
                             isIncoming: false),
            MessageCellModel(text: "Заедьте тогда по возможности",
                             isIncoming: true),
            MessageCellModel(text: "Сейчас я примерно список накидаю",
                             isIncoming: true),
            MessageCellModel(text: """
            Нас поедет 6 человек. Возьмите тогда 6 литров сока на ваш выбор, сосиски мы взяли уже.
            Углей пачку древесных и вещей теплых, а то у воды прохладно будет
            """,
                             isIncoming: true)
        ]
        let lastMessage = MessageCellModel(text: finalMessage,
                                           isIncoming: true)
        defaultMessages.append(lastMessage)
        return defaultMessages
    }
}
