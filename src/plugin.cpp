#include "logger.h"

namespace {
    void TestPlayerPerk() {
        auto* player = RE::PlayerCharacter::GetSingleton();
        constexpr RE::FormID alchemistPerkID = 0x000BE127; // Alchemist00 in Skyrim.esm
        auto* perk = RE::TESForm::LookupByID<RE::BGSPerk>(alchemistPerkID);
        if (!player || !perk) {
            logger::error("kDataLoaded perk test skipped: player={}, perk={}", player != nullptr, perk != nullptr);
            return;
        }

        const bool before = player->HasPerk(perk);
        logger::info("kDataLoaded: Alchemist00 ({:08X}), HasPerk before AddPerk={}", perk->GetFormID(), before);
        if (before) {
            logger::warn("Perk test skipped: player already has the test perk");
            return;
        }

        player->AddPerk(perk);
        const bool after = player->HasPerk(perk);
        logger::info("kDataLoaded: HasPerk immediately after AddPerk={}", after);
        player->RemovePerk(perk);
        logger::info("kDataLoaded: HasPerk after cleanup={}", player->HasPerk(perk));
    }
}

void OnMessage(SKSE::MessagingInterface::Message* message) {
    if (message->type == SKSE::MessagingInterface::kDataLoaded) {
        TestPlayerPerk();
    }
}

SKSEPluginLoad(const SKSE::LoadInterface *skse) {
    SetupLog();
    logger::info("Plugin loaded");
    SKSE::Init(skse);
    SKSE::GetMessagingInterface()->RegisterListener(OnMessage);
    return true;
}
