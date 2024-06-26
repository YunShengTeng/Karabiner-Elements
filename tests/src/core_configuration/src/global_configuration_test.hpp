#include "core_configuration/core_configuration.hpp"
#include <boost/ut.hpp>

void run_global_configuration_test(void) {
  using namespace boost::ut;
  using namespace boost::ut::literals;

  "global_configuration"_test = [] {
    // empty json
    {
      auto json = nlohmann::json::object();
      krbn::core_configuration::details::global_configuration global_configuration(json,
                                                                                   krbn::core_configuration::error_handling::strict);
      expect(global_configuration.get_check_for_updates_on_startup() == true);
      expect(global_configuration.get_show_in_menu_bar() == true);
      expect(global_configuration.get_show_profile_name_in_menu_bar() == false);
      expect(global_configuration.get_enable_notification_window() == true);
      expect(global_configuration.get_ask_for_confirmation_before_quitting() == true);
      expect(global_configuration.get_unsafe_ui() == false);
    }

    // load values from json
    {
      nlohmann::json json{
          {"check_for_updates_on_startup", false},
          {"show_in_menu_bar", false},
          {"show_profile_name_in_menu_bar", true},
          {"enable_notification_window", false},
          {"ask_for_confirmation_before_quitting", false},
          {"unsafe_ui", true},
      };
      krbn::core_configuration::details::global_configuration global_configuration(json,
                                                                                   krbn::core_configuration::error_handling::strict);
      expect(global_configuration.get_check_for_updates_on_startup() == false);
      expect(global_configuration.get_show_in_menu_bar() == false);
      expect(global_configuration.get_show_profile_name_in_menu_bar() == true);
      expect(global_configuration.get_enable_notification_window() == false);
      expect(global_configuration.get_ask_for_confirmation_before_quitting() == false);
      expect(global_configuration.get_unsafe_ui() == true);

      //
      // Set default values
      //

      global_configuration.set_check_for_updates_on_startup(true);
      global_configuration.set_show_in_menu_bar(true);
      global_configuration.set_show_profile_name_in_menu_bar(false);
      global_configuration.set_enable_notification_window(true);
      global_configuration.set_ask_for_confirmation_before_quitting(true);
      global_configuration.set_unsafe_ui(false);
      nlohmann::json j(global_configuration);
      expect(j.empty());
    }

    // invalid values in json
    {
      nlohmann::json json{
          {"check_for_updates_on_startup", nlohmann::json::array()},
          {"show_in_menu_bar", 0},
          {"show_profile_name_in_menu_bar", nlohmann::json::object()},
          {"enable_notification_window", nlohmann::json::object()},
          {"unsafe_ui", false},
      };
      krbn::core_configuration::details::global_configuration global_configuration(json,
                                                                                   krbn::core_configuration::error_handling::loose);
      expect(global_configuration.get_check_for_updates_on_startup() == true);
      expect(global_configuration.get_show_in_menu_bar() == true);
      expect(global_configuration.get_show_profile_name_in_menu_bar() == false);
      expect(global_configuration.get_enable_notification_window() == true);
      expect(global_configuration.get_ask_for_confirmation_before_quitting() == true);
      expect(global_configuration.get_unsafe_ui() == false);
    }
  };
}
