####### Program Dependencies ########
require 'json'
# Templates - Remember remove or edit these line if you edit the file names etc.
require './modules/module_template'
# Must explicitly include modules to use them, unlike classes which are instantiated (created).
include ModuleTemplate

targets = File.read('transfer_targets.json')
targets = JSON.parse(targets)

clubs_list = [
  'Arsenal', 'Chelsea', 'Leicester City',
  'Liverpool', 'Manchester United', 'Tottenham Hotspur'
]



def filter_clubs_criteria (targets, clubs_list)
  targets.delete_if { |player| player['Appearances'].to_i < 50 }
  targets.delete_if { |player| !clubs_list.include?(player['Club']) }
 
end
def filter_goalkeeper_criteria(targets)
  targets.delete_if { |player| player['Position'] == 'Goalkeeper' && player["Passes"].to_i < 3000 }
  targets.delete_if { |player| player['Position'] == 'Goalkeeper' && player["Passes per match"].to_f < 28.00 }
end
def filter_defender_criteria(targets)
  targets.delete_if { |player| player['Position'] == 'Defender' && player['Tackle success %'].to_i < 81 }
  targets.delete_if { |player| player['Position'] == 'Defender' && player['Red cards'].to_i > 4 }
end

def filter_midfielder_criteria(targets) 
targets.delete_if { |player| player['Position'] == 'Midfielder' && player['Goals'].to_i + player['Assists'].to_i < 80 }
end


def filter_forward_criteria(targets)
targets.delete_if { |player| player['Position'] == 'Forward' && player['Shots'].to_i <= 99 }
targets.delete_if { |player| player['Position'] == 'Forward' && player['Shots on target'].to_i * 100 / player['Shots'].to_i <= 44 }
end



filter_clubs_criteria(targets, clubs_list)
filter_goalkeeper_criteria(targets)
filter_defender_criteria(targets)
filter_midfielder_criteria(targets)
filter_forward_criteria(targets)
# # Then 'write' your sorted transfer targets into the successful_candidates.json file.
File.write('successful_candidates.json', targets.to_json)