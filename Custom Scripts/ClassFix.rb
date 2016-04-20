#==============================================================================
# 
# GaryCXJk - Class Extensions v1.17
# * Last Updated: 2013.10.26
# * Level: Normal
# * Requires: YEA - Class System v1.10+
# * Optional: YEA - Class Specifics v1.00+
#             YEA - Learn Skill Engine v1.00+
#             CXJ - AnimEx v1.01+
# * http://area91.multiverseworks.com/index.php?action=rmvxa_script&view=class_extensions
#==============================================================================
 
$imported = {} if $imported.nil?
$imported["CXJ-ClassExtensions"] = true
 
#==============================================================================
#
# Changelog:
#
#------------------------------------------------------------------------------
# 2013.10.26 - v1.17
#
# * Added: Custom hybrid formula for individual parameters
#
#------------------------------------------------------------------------------
# 2013.02.20 - v1.16
#
# * Fixed: Hide mode 2 not working correctly
# * Fixed: Displaying the wrong subclass leveling up
#
#------------------------------------------------------------------------------
# 2013.01.22 - v1.15
#
# * Fixed: Battle test issues
#
#------------------------------------------------------------------------------
# 2013.01.19 - v1.14
#
# * Added: Option to display experience gain per class
# * Added: change_exp now used for subclass experience gain instead of
#          gain_exp
# * Added: Persistent class experience (carries over to all characters,
#          Savedata Extender compatible)
# * Fixed: Wrong experience gain calculation
#
#------------------------------------------------------------------------------
# 2013.01.18 - v1.13
#
# * Added: A new hybridization method
# * Fixed: Small issues with hybridization
#
#------------------------------------------------------------------------------
# 2013.01.12 - v1.12
#
# * Fixed: Changed how hybridization worked
#
#------------------------------------------------------------------------------
# 2013.01.12 - v1.11
#
# * Fixed: Skills not appearing in the Learn Skill menu
# * Fixed: Changed way it aliases
#
#------------------------------------------------------------------------------
# 2013.01.12 - v1.10
#
# * Added: Combination class names
# * Added: Combination class graphics
#
#------------------------------------------------------------------------------
# 2013.01.12 - v1.09
#
# * Fixed: Major mistakes
#
#------------------------------------------------------------------------------
# 2013.01.09 - v1.08
#
# * Fixed: Minor mistakes
#
#------------------------------------------------------------------------------
# 2013.01.09 - v1.07
#
# * Added: Subclass traits
# * Added: Option to 'hybridize' classes
#
#------------------------------------------------------------------------------
# 2013.01.08 - v1.06
#
# * Added: Fix for parameter using main level instead of class level
# * Fixed: Regular expression mistakes
#
#------------------------------------------------------------------------------
# 2013.01.06 - v1.05
#
# * Added: Learning Skill Engine addon
# * Added: Ability to change class experience rate
# * Added: Experience distribution to subclasses
# * Fixed: Class level not appearing
#
#------------------------------------------------------------------------------
# 2013.01.05 - v1.04
#
# * Added: AnimEx compatibility
# * Added: Subclass learning
# * Added: Skill learning when all classes defined have certain level
# * Fixed: Overlooked mistakes
# * Fixed: Errors in graphics picking
#
#------------------------------------------------------------------------------
# 2013.01.01 - v1.03
#
# * Fixed: Wrong calculation of class level
#
#------------------------------------------------------------------------------
# 2012.12.31 - v1.02
#
# * Fixed: Player sprite not changing
#
#------------------------------------------------------------------------------
# 2012.12.31 - v1.01
#
# * Added: Ability to hide classes that are unavailable for primary or subclass
#          (requires Class Specifics)
# * Fixed: Some errors
#
#------------------------------------------------------------------------------
# 2012.12.31 - v1.00
#
# * Initial release
#
#==============================================================================
#
# Yanfly's Class System is a very solid script, but it is missing a few small
# things. This scripts adds just the little things it is missing.
#
# Some ideas came from members from the community. haothehare gave me the idea
# to start this entire project with the level limiter. Both haothehare and
# Titanhex gave me the idea for class-specific graphics. Crossroads gave me
# some good ideas for compatibility with the Learn Skill Engine. Spitfire71
# and TSA Ryan came with the idea of hybridizing classes, with thedrifter148
# bringing it up.
#
#==============================================================================
#
# Installation:
#
# Make sure to put this below Materials, but above Main Process.
#
# This script overrides several methods. If you are sure no method that is
# used by other scripts get overridden, you can place it anywhere, otherwise,
# make sure this script is loaded first. Do know that there is a possibility
# that this script will stop working due to that.
#
# This script adds aliases for several methods. If you are sure no method that
# is used by other scripts get overridden, you can place it anywhere,
# otherwise, make sure this script is loaded after any other script overriding
# these methods, otherwise this script stops working.
#
# This script requires another script to run. Put this script after the
# required scripts to make it work properly.
#
# This script has additional functionality and / or compatibility with other
# scripts. In order to benifit the most out of it, it is advised to place this
# script after the others.
#
#------------------------------------------------------------------------------
# Overridden methods:
#
# * class Game_Actor
#   - init_skills (if USE_PERSISTENT_CLASS_LEVEL is set)
#   - learn_class_skills(class_id) (if USE_PERSISTENT_CLASS_LEVEL is set)
#   - skills (if USE_PERSISTENT_CLASS_LEVEL is set)
#   - class_level(class_id) (from Class System)
#   - level_up
#   - display_level_up
# * class Window_Base
#   - draw_actor_class(actor, x, y, width = 112)
# * class Scene_Class (from Class System)
#   - create_help_window
# * class Window_ClassList (from Class System)
#   - make_item_list
#
#------------------------------------------------------------------------------
# Aliased methods:
#
# * module DataManager
#   - load_database
#   - make_save_contents (if Savedata Extender is not installed)
#   - extract_save_contents (if Savedata Extender is not installed)
# * class Game_Actor
#   - setup(actor_id) (if USE_PERSISTENT_CLASS_LEVEL is set)
#   - change_exp(exp, show)
#   - feature_objects
# * class Window_ClassList (from Class System)
#   - set_item_colour
# * class Window_LearnSkillList (from Learn Skill Engine)
#   - meet_requirements?(item)
#
#==============================================================================
#
# Usage:
#
# There are various functionalities in this script. You can enable and disable
# them by specifying it in the script. I'll go through them one at a time.
#
#------------------------------------------------------------------------------
# Class Level Limiter:
#
# This allows you to limit the class level cap. This means that classes will
# never go over the level cap you specified. You can also specify a limit
# for a specific class using notetags.
#
# <max level: x>
#
#------------------------------------------------------------------------------
# Skill Unlock by Class Level:
#
# Normally when you level up, regardless of the class level you will unlock
# skills based on your current actor's level. In order to change that, add
# the following to the skill learning notetag:
#
# <use other level>
#
# This will pick the level based on several things:
# - If YEA::CLASS_SYSTEM::MAINTAIN_LEVELS is set to true, use the actor's
#     level;
# - If CXJ::CLASS_EXTENSION::SWITCH_MAIN_LEVEL is set to true, use the class
#     level when not set, otherwise use main level;
# - Use main level when not set, otherwise use class level.
#
# You can also directly set the class levels in the skills, which has the
# added bonus that you can assign multiple class level requirements for one
# skill. You use the same syntax as that of the Class Unlock Level script.
#
# <level unlock requirements>
#   class x: level y
#   class x: level y
# </level unlock requirements>
#
# When Learn Skill Engine is installed, you can also assign multiple classes
# to skills that could be learned using this engine. Skills can only be
# learned if all classes have reached a certain level, and will appear in
# all classes, unless specified.
#
# <level unlock requirements>
#   class x: level y
#   class x: level y[ exclude]
# </level unlock requirements>
#
# When exclude is added to the end, a skill will not appear in the skill
# learning list of that class.
#
#------------------------------------------------------------------------------
# Experience:
#
# You can change experience rate and experience distribution. Changing the
# experience rate is the same as modifying the experience learning curve,
# except you'll earn lower experience instead of having to earn more
# experience. This especially can be handy when skills that can be learned
# using the Learn Skill Engine use experience.
#
# <experience rate: x%>
# <experience rate: [+-*]x%>
#
# As a standard, the experience rate is 1.00, or 100%. You can use operators
# to modify the experience accordingly. For example, if the new rate is -10%,
# the rate will change to 90%.
#
# The same can be used for the subclass experience distribution. There are two
# modes. Either the main class experience remains unaffected or it will share
# its experience with the subclass. You can enable or disable it by using the
# following notetag:
#
# <split experience on>
# <split experience off>
#
# When set to off, subclasses will still earn experience, but it will not
# affect main classes. You can also set the default in the script.
#
# Finally, you can set the subclass experience ratio by using the following:
#
# <subclass experience ratio: x%>
# <subclass experience ratio: [+-*]x%>
#
#------------------------------------------------------------------------------
# Custom Hybrid Formulas:
#
# When set as a subclass, normally the stats get combined based on what you
# set it to in the settings. However, sometimes you want to set these stats
# based on certain formulas.
#
# <hybrid formula>
# ...
# </hybrid formula>
#
# You can also specify the formulas for each main class.
#
# <hybrid formula class_no>
# ...
# </hybrid formula>
#
# In the latter's case, this means that when the current class is set as a
# subclass of class_no, the stats will get modified based on the formulas
# given.
#
# Formulas are easy. First, you need to know that I've used the base
# abrevations as shown on the English version of the database, that is,
# mhp, mmp, atk, def, mat, mdf, agi and luk. They are all in lower case.
# Second, in order to define whether the main class or the subclass is meant,
# you should prefix each stat in the formula with either main. for main class
# or sub. for subclass.
#
# <hybrid formula>
# atk: (1.5 * main.atk + 0.5 * sub.atk) / 2.0
# def: (main.def + 0.4 * sub.def + 0.1 * sub.agi) / 1.25
# </hybrid formula>
#
# You can indeed mix and match the formulas, and all formulas are calculated
# from the base stats on the level the class is on, without any buffs.
#
#------------------------------------------------------------------------------
# Class combo names:
#
# You can set special class combination names.
#
# <subclass name combo: class_no, Class combo name>
#
#------------------------------------------------------------------------------
# Class Graphics:
#
# If you want classes to have generic appearances, or if you want an actor to
# have a specific graphics set when using a certain class.
#
# You can set a generic class graphics set, which is a set of data which
# specifies the default class graphic. You can specify multiple sets here. It
# defaults to the "DEFAULT" set, but you can use a notetag on the actor to
# specify a specific graphics set.
#
# <generic set: x>
#
# Where x is the string defining the graphics set. Note that this graphics set
# is also used for combination class graphics when that's enabled.
#
# By default, you can set all classes to either opt in or opt out. What this
# means is that you can specify if actor uses the generic set or not, depending
# on the settings. If an actor opts in, it means that it will use the generic
# set, otherwise it doesn't. You can set the default settings in the script,
# but using notetags you can also specify it per actor.
#
# <graphics opt in>
# <graphics opt out>
#
# You can also set a class specific graphic for the actor itself. You can even
# set combination class graphics, although it is optional.
#
# <character set: class_id[, subclass_id], character_name, character_index>
# <face set: class_id[, subclass_id], face_name, face_index>
#
# Finally, on the classes themselves you can specify a default graphic.
# Depending on the script settings, these will have priority over the default
# settings.
#
# <character set[ subclass_id]: character_name, character_index>
# <face set[ subclass_id]: face_name, face_index>
#
#------------------------------------------------------------------------------
# AnimEx compatibility:
#
# This script has compatibility modifications for AnimEx, so that both scripts
# can be used. You will have to add whether they have diagonal sprites or not
# if the sprite doesn't have eight or nine animation rows.
#
#==============================================================================
#
# License:
#
# Creative Commons Attribution 3.0 Unported
#
# The complete license can be read here:
# http://creativecommons.org/licenses/by/3.0/legalcode
#
# The license as it is described below can be read here:
# http://creativecommons.org/licenses/by/3.0/deed
#
# You are free:
#
# to Share — to copy, distribute and transmit the work
# to Remix — to adapt the work
# to make commercial use of the work
#
# Under the following conditions:
#
# Attribution — You must attribute the work in the manner specified by the
# author or licensor (but not in any way that suggests that they endorse you or
# your use of the work).
#
# With the understanding that:
#
# Waiver — Any of the above conditions can be waived if you get permission from
# the copyright holder.
#
# Public Domain — Where the work or any of its elements is in the public domain
# under applicable law, that status is in no way affected by the license.
#
# Other Rights — In no way are any of the following rights affected by the
# license:
#
# * Your fair dealing or fair use rights, or other applicable copyright
#   exceptions and limitations;
# * The author's moral rights;
# * Rights other persons may have either in the work itself or in how the work
#   is used, such as publicity or privacy rights.
#
# Notice — For any reuse or distribution, you must make clear to others the
# license terms of this work. The best way to do this is with a link to this
# web page.
#
#------------------------------------------------------------------------------
# Extra notes:
#
# Despite what the license tells you, I will not hunt down anybody who doesn't
# follow the license in regards to giving credits. However, as it is common
# courtesy to actually do give credits, it is recommended that you do.
#
# As I picked this license, you are free to share this script through any
# means, which includes hosting it on your own website, selling it on eBay and
# hang it in the bathroom as toilet paper. Well, not selling it on eBay, that's
# a dick move, but you are still free to redistribute the work.
#
# Yes, this license means that you can use it for both non-commercial as well
# as commercial software.
#
# You are free to pick the following names when you give credit:
#
# * GaryCXJk
# * Gary A.M. Kertopermono
# * G.A.M. Kertopermono
# * GARYCXJK
#
# Personally, when used in commercial games, I prefer you would use the second
# option. Not only will it actually give me more name recognition in real
# life, which also works well for my portfolio, it will also look more
# professional. Also, do note that I actually care about capitalization if you
# decide to use my username, meaning, capital C, capital X, capital J, lower
# case k. Yes, it might seem stupid, but it's one thing I absolutely care
# about.
#
# Finally, if you want my endorsement for your product, if it's good enough
# and I have the game in my posession, I might endorse it. Do note that if you
# give me the game for free, it will not affect my opinion of the game. It
# would be nice, but if I really did care for the game I'd actually purchase
# it. Remember, the best way to get any satisfaction is if you get people to
# purchase the game, so in a way, I prefer it if you don't actually give me
# a free copy.
#
# This script was originally hosted on:
# http://area91.multiverseworks.com
#
# Don't forget to include the credits of the original script as well.
#
#==============================================================================
#
# The code below defines the settings of this script, and are there to be
# modified.
#
#==============================================================================
 
module CXJ
  module CLASS_EXTENSIONS
    #------------------------------------------------------------------------
    # Class Level Limiter
    #------------------------------------------------------------------------
    ENABLE_CLASS_LEVEL_LIMITER = true       # Defines if you want to limit
                                            # class levels
    DEFAULT_MAX_LEV = 45                    # Defines the max level
    STOP_GAINING_EXP_AFTER_MAX = true       # Stops experience gain after
                                            # hitting the level cap
    STOP_LEVELING_AFTER_CLASS_MAX = true    # Stops leveling main character
                                            # after hitting the experience
                                            # cap.
     
    #------------------------------------------------------------------------
    # Generic Class Graphics
    #------------------------------------------------------------------------
    # When you set these, all characters will use this list as their initial
    # graphics. You can pick between an opt-in or opt-out. When you pick
    # opt-in, characters won't use these generic class graphics unless they
    # chose to, otherwise they will always use these generic class graphics
    # unless either the character has set their custom graphics or they opt
    # out.
    #
    # Also, notetags specified in the database have priority over this list,
    # meaning that any class that has a custom class graphic set in the
    # notetags will have that as the generic class graphic. You can however
    # change it below to have generic class graphics have priority instead.
    #
    # Finally, when the graphics for a certain class isn't set here, it will
    # always default to the default character graphics.
    #------------------------------------------------------------------------
     
    ENABLE_CLASS_SPECIFIC_GRAPHICS = true   # Defines whether to use class
                                            # specific graphics.
    OPT_IN_CLASS_GRAPHICS = false           # Defines if you want to opt in.
    CLASS_SPECIFIED_HAS_PRIORITY = true     # Graphics defined in class
                                            # notetags have priority.
    ENABLE_COMBO_SPECIFIC_GRAPHICS = true   # Defines whether to use class
                                            # specific graphics with combos.
                                            # Disabled when class specific
                                            # graphics is set to false.
     
    GENERIC_CLASS_GRAPHICS = {}
    GENERIC_CLASS_GRAPHICS["DEFAULT"] = {
    # ClassID => [  CharacterName,  CharacterIndex, FaceName,   FaceIndex ],
      1       => [  "Actor1",       0,              "Actor1",   0 ],
      3       => [  "Actor3",       3,              "Actor3",   3 ],
    }
     
    COMBO_CLASS_GRAPHICS = {}
    COMBO_CLASS_GRAPHICS["DEFAULT"] = {}
    COMBO_CLASS_GRAPHICS["DEFAULT"][3] = {
    # ClassID => [  CharacterName,  CharacterIndex, FaceName,   FaceIndex ],
     1        => [  "Actor5",       2,              "Actor5",   2],
    }
 
    #------------------------------------------------------------------------
    # Miscellaneous
    #------------------------------------------------------------------------
     
    # Set the class hiding mode for the class list window. Requires the
    # Class Specifics addon.
    # 0: Original
    # 1: Hide unavailable
    # 2: Grey out selected in other type
    CLASS_HIDE_MODE = 1
 
    # When false, actor level is the main level, otherwise, class level is
    # the main level.
    SWITCH_MAIN_LEVEL = false
     
    # When false, main class experience gain remains normal, when true,
    # experience gain is reduced when shared with subclass.
    SPLIT_TO_SUB = false
     
    # The base amount of experience gain for subclasses in comparison to the
    # main class gain.
    EXP_TO_SUBCLASS = 1.00
     
    # Use class level for parameter calculation.
    CLASS_LEVEL_PARAMS = true
     
    # Checks whether subclasses can set traits or not.
    SUBCLASS_TRAITS = true
     
    # Instead of adding subclass stats, average between the two. There are
    # several moodes.
    # :none       - Don't use hybridization
    # :add        - Add subclass to full main class stats
    # :ratio      - Use subclass rate as a ratio, subtracting from main class
    # :normalize  - Like :add, but normalizes
    HYBRIDIZE = :none
     
    # Shows class experience gain.
    SHOW_CLASS_EXP_GAIN = {
    :charlevel => true,      # Displays the new character level
    :classexp => false,       # Displays the experience gain per class
    :classlevel => false,      # Displays the new class level
    }
     
    # Use persistent class level.
    # All characters share the same class level.
    USE_PERSISTENT_CLASS_LEVEL = true
     
    #------------------------------------------------------------------------
    # AnimEx compatibility
    # Define below
    #------------------------------------------------------------------------
    GENERIC_CLASS_HAS_DIAGONAL = {}
    GENERIC_CLASS_HAS_DIAGONAL["DEFAULT"] = {
    # ClassID => HasDiagonal?,
      1       => false,
      3       => false,
    }
     
    COMBO_CLASS_HAS_DIAGONAL = {}
    COMBO_CLASS_HAS_DIAGONAL["DEFAULT"] = {}
    COMBO_CLASS_HAS_DIAGONAL["DEFAULT"][3] = {
    # ClassID => HasDiagonal?,
     1        => false,
    }
     
    module VOCAB
      #----------------------------------------------------------------------
      # Vocab
      #----------------------------------------------------------------------
      # This module contains the generic vocabulary of this script.
      #----------------------------------------------------------------------
      CHARACTER_LEVELED_UP = "%s leveled up!"
      CLASS_EXP_GAINED = "%s received %s EXP!"
    end
  end
end
 
#==============================================================================
#
# The code below should not be altered unless you know what you're doing.
#
#==============================================================================
 
if $imported["YEA-ClassSystem"]
  module CXJ
    module REGEXP
      module CLASS
         
        MAX_LEVEL = /<(?:MAX_LEVEL|max level):\s*(\d+)>/i
        CHARSET   = /<(?:CHARACTER_SET|CHARSET|character set|charset):\s*(.+?)\s*,\s*(\d+)>/i
        FACESET   = /<(?:FACE_SET|FACESET|face set|faceset):\s*(.+?)\s*,\s*(\d+)>/i
        CHARSET_S = /<(?:CHARACTER_SET|CHARSET|character set|charset)\s*(\d+)\s*:\s*(.+?)\s*,\s*(\d+)>/i
        FACESET_S = /<(?:FACE_SET|FACESET|face set|faceset)\s*(\d+)\s*:\s*(.+?)\s*,\s*(\d+)>/i
        EXP_RATE  = /<(?:EXPERIENCE_RATE|experience rate):\s*([\+\-\*]?)(\d+)\%>/i
        SUB_RATIO = /<(?:SUBCLASS_EXPERIENCE_RATIO|subclass experience ratio):\s*([\+\-\*]?)(\d+)\%>/i
        EXP_SPLIT = /<(?:SPLIT_EXPERIENCE|split experience) (on|off)>/
        SUB_COMBO = /<(?:SUBCLASS_NAME_COMBO|subclass name combo):\s*(\d+)\s*,\s*(.+?)>/i
        # AnimEx compatibility
        HAS_DIAG  = /<(?:SPRITE_HAS_DIAGONAL|sprite has diagonal)>/i
        # Custom class hybridization
        HF_ON     = /<(?:HYBRID_FORMULA|hybrid formula)>/i
        HF2_ON    = /<(?:HYBRID_FORMULA|hybrid formula)\s+(\d+)>/i
        HF_OFF    = /<\/(?:HYBRID_FORMULA|hybrid formula)>/i
        HF_FORMS  = /^\s*(\w+):\s+(.+?)\s*$/i
         
      end
      module ACTOR
         
        OPT_IN    = /<(?:GRAPHICS_OPT_IN|graphics opt) (in|out)>/i
        GENERICSET = /<(?:GENERIC_SET|generic set):\s*(.+?)>/i
        CHARSET   = /<(?:CHARACTER_SET|CHARSET|character set|charset):\s*(\d+)\s*,\s*(.+?)\s*,\s*(\d+)>/i
        FACESET   = /<(?:FACE_SET|FACESET|face set|faceset):\s*(\d+)\s*,\s*(.+?)\s*,\s*(\d+)>/i
        CHARSET_S = /<(?:CHARACTER_SET|CHARSET|character set|charset):\s*(\d+)\s*,\s*(\d+)\s*,\s*(.+?)\s*,\s*(\d+)>/i
        FACESET_S = /<(?:FACE_SET|FACESET|face set|faceset):\s*(\d+)\s*,\s*(\d+)\s*,\s*(.+?)\s*,\s*(\d+)>/i
        # AnimEx compatibility
        HAS_DIAG  = /<(?:SPRITE_HAS_DIAGONAL|sprite has diagonal):\s*(\d+)>/i
        HAS_DIA_S = /<(?:SPRITE_HAS_DIAGONAL|sprite has diagonal):\s*(\d+)\s*,\s*(\d+)>/i
         
      end
      module LEARNING
        USE_OTHER  = /<(?:USE_OTHER_LEVEL|use other level)>/i
      end
      module SKILL
        LV_UNLOCK_ON =
          /<(?:LEVEL_UNLOCK_REQUIREMENTS|level unlock requirements)>/i
        LV_UNLOCK_OFF =
          /<\/(?:LEVEL_UNLOCK_REQUIREMENTS|level unlock requirements)>/i
        LV_LEARN_UNLOCK_ON =
          /<(?:LEARN_REQUIRE_CLASS_LEVEL|learn require class level)>/i
        LV_LEARN_UNLOCK_OFF =
          /<\/(?:LEARN_REQUIRE_CLASS_LEVEL|learn require class level)>/i
        LV_UNLOCK_STR = /CLASS[ ](\d+): LEVEL[ ](\d+)(?: (EXCLUDE))?/i
      end
    end
  end
 
  #============================================================================
  # ** DataManager
  #----------------------------------------------------------------------------
  #  This module manages the database and game objects. Almost all of the 
  # global variables used by the game are initialized by this module.
  #============================================================================
 
  module DataManager
    #------------------------------------------------------------------------
    # Alias: load_database
    #------------------------------------------------------------------------
    class << self
      load_database_cxj_ce = instance_method(:load_database)
      define_method :load_database do
        load_database_cxj_ce.bind(self).call
        load_notetags_cxj_ce
      end
    end
     
    #------------------------------------------------------------------------
    # New: load_notetags_cul
    #------------------------------------------------------------------------
    def self.load_notetags_cxj_ce
      groups = [$data_classes, $data_actors, $data_skills]
      for group in groups
        for obj in group
          next if obj.nil?
          obj.load_notetags_cxj_ce
        end
      end
    end
 
    #------------------------------------------------------------------------
    # * Alias: Create Game Objects
    #------------------------------------------------------------------------
    class << self
      datamanager_create_game_objects_cxj_ce = instance_method(:create_game_objects)
      define_method :create_game_objects do
        datamanager_create_game_objects_cxj_ce.bind(self).call
        $game_persistent_class = {}
        $game_persistent_skills = {}
      end
    end
     
    if !$imported["CXJ-SavedataExtender"]
      #----------------------------------------------------------------------
      # * Alias: Create Save Contents
      #----------------------------------------------------------------------
      class << self
        datamanager_make_save_contents_cxj_ce = instance_method(:make_save_contents)
        define_method :make_save_contents do
          contents = datamanager_make_save_contents_cxj_ce.bind(self).call
          contents[:persistent_class] = $game_persistent_class
          contents[:persistent_skills] = $game_persistent_skills
          contents
        end
      end
      #----------------------------------------------------------------------
      # * Alias: Extract Save Contents
      #----------------------------------------------------------------------
      class << self
        datamanager_extract_save_contents_cxj_ce = instance_method(:extract_save_contents)
        define_method :extract_save_contents do |contents|
          datamanager_extract_save_contents_cxj_ce.bind(self).call(contents)
          $game_persistent_class = contents[:persistent_class]
          $game_persistent_skills = contents[:persistent_skills]
        end
      end
    else
      #----------------------------------------------------------------------
      # * New: Save Class Data
      #----------------------------------------------------------------------
      def self.save_class_data
        contents = {}
        contents[:persistent_class] = $game_persistent_class
        contents[:persistent_skills] = $game_persistent_skills
        contents
      end
       
      #----------------------------------------------------------------------
      # * New: Load Class Data
      #----------------------------------------------------------------------
      def self.load_class_data(contents)
        $game_persistent_class = contents[:persistent_class]
        $game_persistent_skills = contents[:persistent_skills]
      end
       
      CXJ::SAVEDATA_EXTENDER::add_save_handler(self.method(:save_class_data), false, true)
      CXJ::SAVEDATA_EXTENDER::add_load_handler(self.method(:load_class_data))
    end
 
  end
  #============================================================================
  # ** RPG::Class::Learning
  #============================================================================
 
  class RPG::Class::Learning
    attr_accessor :use_other
     
    #------------------------------------------------------------------------
    # common cache: load_notetags_cxj_ce
    #------------------------------------------------------------------------
    def load_notetags_cxj_ce
      @use_other = false
      self.note.split(/[\r\n]+/).each { |line|
        case line
        when CXJ::REGEXP::LEARNING::USE_OTHER
          @use_other = true
        end
      }
    end
  end
 
  #============================================================================
  # ** RPG::Class
  #============================================================================
 
  class RPG::Class < RPG::BaseItem
 
    attr_accessor :max_level
    attr_accessor :experience_rate
    attr_accessor :subclass_ratio
    attr_accessor :experience_split
    attr_reader   :has_diagonal
    attr_reader   :combined_name
     
    STAT_NAMES = ["mhp", "mmp", "atk", "def", "mat", "mdf", "agi", "luk"]
     
    #------------------------------------------------------------------------
    # common cache: load_notetags_cxj_ce
    #------------------------------------------------------------------------
    def load_notetags_cxj_ce
      @max_level = -1
      @character = {}
      @face = {}
      @experience_rate = 1.00
      @subclass_ratio = CXJ::CLASS_EXTENSIONS::EXP_TO_SUBCLASS
      @experience_split = CXJ::CLASS_EXTENSIONS::SPLIT_TO_SUB
      @combined_name = {}
      @custom_hybrid_formula = []
       
      tag = []
       
      self.note.split(/[\r\n]+/).each { |line|
        case line
        when CXJ::REGEXP::CLASS::MAX_LEVEL
          @max_level = $1.to_i
        when CXJ::REGEXP::CLASS::CHARSET
          @character[0] = {} if @character[0].nil?
          @character[0][:character_name] = $1
          @character[0][:character_index] = $2.to_i
 
          # AnimEx compatibility
          @character[0][:has_diagonal] = false
          @character[0][:is_regular] = true
          if $imported["CXJ-AnimEx"] && !@character[0][:character_name].empty? && @character[0][:character_name] =~ /^\!?\[(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)(?:\s*,\s*(1|0))?\]/
            @character[0][:is_regular] = false if([8, 9].include?($4.to_i))
          end
        when CXJ::REGEXP::CLASS::FACESET
          @face[0] = {} if @face[0].nil?
          @face[0][:face_name] = $1
          @face[0][:face_index] = $2.to_i
        when CXJ::REGEXP::CLASS::CHARSET_S
          id = $1.to_i
          @character[id] = {} if @character[id].nil?
          @character[id][:character_name] = $2
          @character[id][:character_index] = $3.to_i
           
          # AnimEx compatibility
          @character[id][:has_diagonal] = false
          @character[id][:is_regular] = true
          if $imported["CXJ-AnimEx"] && !@character[id][:character_name].empty? && @character[id][:character_name] =~ /^\!?\[(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)(?:\s*,\s*(1|0))?\]/
            @character[id][:is_regular] = false if([8, 9].include?($4.to_i))
          end
        when CXJ::REGEXP::CLASS::FACESET_S
          id = $1.to_i
          @face[id] = {} if @face[id].nil?
          @face[id][:face_name] = $2
          @face[id][:face_index] = $3.to_i
        when CXJ::REGEXP::CLASS::EXP_RATE
          rate = $2.to_i * 0.01
          case $1
          when "+"
            @experience_rate+= rate
          when "-"
            @experience_rate-= rate
          when "*"
            @experience_rate*= rate
          else
            @experience_rate = rate
          end
        when CXJ::REGEXP::CLASS::SUB_RATIO
          rate = $2.to_i * 0.01
          case $1
          when "+"
            @subclass_ratio+= rate
          when "-"
            @subclass_ratio-= rate
          when "*"
            @subclass_ratio*= rate
          else
            @subclass_ratio = rate
          end
        when CXJ::REGEXP::CLASS::EXP_SPLIT
          @experience_split = true if $1 == "on"
          @experience_split = false if $1 == "off"
        when CXJ::REGEXP::CLASS::SUB_COMBO
          @combined_name[$1.to_i] = $2
           
        # AnimEx compatibility
        when CXJ::REGEXP::CLASS::HAS_DIAG
          @has_diagonal = true
           
        when CXJ::REGEXP::CLASS::HF_ON
          @custom_hybrid_formula[0] = [] if @custom_hybrid_formula[0].nil?
          tag.push(0)
        when CXJ::REGEXP::CLASS::HF2_ON
          class_no = $1.to_i
          @custom_hybrid_formula[class_no] = [] if @custom_hybrid_formula[class_no].nil?
          tag.push(class_no)
        when CXJ::REGEXP::CLASS::HF_OFF
          tag.pop unless tag.empty?
        when CXJ::REGEXP::CLASS::HF_FORMS
          unless tag.empty? || !STAT_NAMES.include?($1.downcase)
            class_no = tag[-1]
            @custom_hybrid_formula[class_no][STAT_NAMES.index($1.downcase)] = $2
          end
        end
      }
       
      self.learnings.each do |learning|
        learning.load_notetags_cxj_ce
      end
       
    end
     
    def custom_hybrid_formula(param, class_no = 0)
      if param.kind_of?(String)
        if !param.is_number?
          return nil if !STAT_NAMES.include?(param.downcase)
          param = STAT_NAMES.index(skill.downcase)
        else
          param = skill.to_i
        end
      end
      class_no = 0 if @custom_hybrid_formula[class_no].nil? || @custom_hybrid_formula[class_no][param].nil?
      return @custom_hybrid_formula[class_no][param] unless @custom_hybrid_formula[class_no].nil? || @custom_hybrid_formula[class_no][param].nil?
    end
     
    #------------------------------------------------------------------------
    # * New: Character
    #------------------------------------------------------------------------
    def character(sub_id = 0)
      return @character[sub_id] if CXJ::CLASS_EXTENSIONS::ENABLE_COMBO_SPECIFIC_GRAPHICS && !@character[sub_id].nil?
      return @character[0] if !@character[0].nil?
      return nil
    end
     
    #------------------------------------------------------------------------
    # * New: Face
    #------------------------------------------------------------------------
    def face(sub_id = 0)
      return @face[sub_id] if CXJ::CLASS_EXTENSIONS::ENABLE_COMBO_SPECIFIC_GRAPHICS && !@face[sub_id].nil?
      return @face[0] if !@face[0].nil?
      return nil
    end
     
    #------------------------------------------------------------------------
    # * Override: Character Index
    #------------------------------------------------------------------------
    def character_index(d = 0, sub_id = 0)
      char = character(sub_id)
      return 0 if char.nil?
      char[:is_regular] && char[:has_diagonal] && d % 2 != 0 ? char[:character_index] + 1 : char[:character_index]
    end
  end
 
  #============================================================================
  # ** RPG::Skill
  #============================================================================
 
  class RPG::Skill < RPG::UsableItem
     
    attr_accessor :level_unlock
    attr_accessor :level_learn_unlock
    #------------------------------------------------------------------------
    # common cache: load_notetags_cxj_ce
    #------------------------------------------------------------------------
    def load_notetags_cxj_ce
      @level_unlock = {}
      @level_learn_unlock = {}
      class_exclude = []
      tag = 0
      self.note.split(/[\r\n]+/).each { |line|
        case line
        when CXJ::REGEXP::SKILL::LV_UNLOCK_ON
          tag = 1 if tag == 0
        when CXJ::REGEXP::SKILL::LV_UNLOCK_OFF
          tag = 0 if tag == 1
         
        # Learn Skill Engine compatibility
        when CXJ::REGEXP::SKILL::LV_LEARN_UNLOCK_ON
          tag = 2 if tag == 0
        when CXJ::REGEXP::SKILL::LV_LEARN_UNLOCK_OFF
          tag = 0 if tag == 2
         
        when CXJ::REGEXP::SKILL::LV_UNLOCK_STR
          @level_unlock[$1.to_i] = $2.to_i if tag == 1
           
          # Learn Skill Engine compatibility
          @level_learn_unlock[$1.to_i] = $2.to_i if tag == 2
          if !$3.nil? && $3.downcase == "exclude"
            class_exclude.push($1.to_i)
          end
        end
      }
      $skill_class_unlock = [] if $skill_class_unlock.nil?
      $skill_class_unlock.push(self) if !@level_unlock.empty?
       
      # Learn Skill Engine compatibility
      remove_level = []
      @level_learn_unlock.each_key do |class_id|
        if $data_classes[class_id].nil?
          remove_level.push(class_id)
        else
          skill_id = $data_skills.index(self)
          $data_classes[class_id].learn_skills = [] if $data_classes[class_id].learn_skills.nil?
          $data_classes[class_id].learn_skills.push(skill_id) if !class_exclude.include(class_id)
        end
      end
      remove_level.each do |class_id|
        @level_learn_unlock.delete(class_id)
      end
      remove_level.clear
    end
  end
   
  #============================================================================
  # ** RPG::Actor
  #============================================================================
 
  class RPG::Actor < RPG::BaseItem
     
    attr_accessor :class_graphics
    attr_accessor :graphics_opt_in
    attr_accessor :generic_set
     
    #------------------------------------------------------------------------
    # common cache: load_notetags_cxj_ce
    #------------------------------------------------------------------------
    def load_notetags_cxj_ce
      @class_graphics = {}
      @graphics_opt_in = !CXJ::CLASS_EXTENSIONS::OPT_IN_CLASS_GRAPHICS
      @generic_set = "DEFAULT"
      self.note.split(/[\r\n]+/).each { |line|
        case line
        when CXJ::REGEXP::ACTOR::OPT_IN
          @graphics_opt_in = false
          @graphics_opt_in = true if $1.downcase == "in"
        when CXJ::REGEXP::ACTOR::GENERICSET
          @generic_set = $1 if !CXJ::CLASS_EXTENSIONS::GENERIC_CLASS_GRAPHICS[$i].nil?
        when CXJ::REGEXP::ACTOR::CHARSET
          @class_graphics[$1.to_i] = {} if @class_graphics[$1.to_i].nil?
          @class_graphics[$1.to_i][0] = {} if @class_graphics[$1.to_i][0].nil?
          @class_graphics[$1.to_i][0][:character_name] = $2
          @class_graphics[$1.to_i][0][:character_index] = $3.to_i
           
          # AnimEx compatibility
          @class_graphics[$1.to_i][0][:is_regular] = true
           
        when CXJ::REGEXP::ACTOR::FACESET
          @class_graphics[$1.to_i] = {} if @class_graphics[$1.to_i].nil?
          @class_graphics[$1.to_i][0] = {} if @class_graphics[$1.to_i][0].nil?
          @class_graphics[$1.to_i][0][:face_name] = $2
          @class_graphics[$1.to_i][0][:face_index] = $3.to_i
         
        # AnimEx compatibility
        when CXJ::REGEXP::ACTOR::HAS_DIAG
          @class_graphics[$1.to_i][0] = {} if @class_graphics[$1.to_i].nil?
          @class_graphics[$1.to_i][0][:has_diagonal] = true
 
        when CXJ::REGEXP::ACTOR::CHARSET_S
          @class_graphics[$1.to_i] = {} if @class_graphics[$1.to_i].nil?
          @class_graphics[$1.to_i][$2.to_i] = {} if @class_graphics[$1.to_i][$2.to_i].nil?
          @class_graphics[$1.to_i][$2.to_i][:character_name] = $3
          @class_graphics[$1.to_i][$2.to_i][:character_index] = $4.to_i
           
          # AnimEx compatibility
          @class_graphics[$1.to_i][$2.to_i][:is_regular] = true
           
        when CXJ::REGEXP::ACTOR::FACESET_S
          @class_graphics[$1.to_i] = {} if @class_graphics[$1.to_i].nil?
          @class_graphics[$1.to_i][$2.to_i] = {} if @class_graphics[$1.to_i][$2.to_i].nil?
          @class_graphics[$1.to_i][$2.to_i][:face_name] = $3
          @class_graphics[$1.to_i][$2.to_i][:face_index] = $4.to_i
         
        # AnimEx compatibility
        when CXJ::REGEXP::ACTOR::HAS_DIA_S
          @class_graphics[$1.to_i][$2.to_i] = {} if @class_graphics[$1.to_i].nil?
          @class_graphics[$1.to_i][$2.to_i][:has_diagonal] = true
           
        end
      }
       
      # AnimEx compatibility
      @class_graphics.each do |key, value|
        value.each do |subkey, subvalue|
          if $imported["CXJ-AnimEx"] && !subvalue[:character_name].nil? && subvalue[:character_name] =~ /^\!?\[(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)(?:\s*,\s*(1|0))?\]/
            @class_graphics[key][subkey][:is_regular] = false if([8, 9].include?($4.to_i))
          end
        end
      end
       
    end
  end
 
 
  #============================================================================
  # ** Game_Actor
  #----------------------------------------------------------------------------
  #  This class handles actors. It is used within the Game_Actors class
  # ($game_actors) and is also referenced from the Game_Party class ($game_party).
  #============================================================================
 
  class Game_Actor < Game_Battler
     
    attr_reader :subclass_id
     
    class Game_Actor_Params
      attr_accessor :mhp
      attr_accessor :mmp
      attr_accessor :atk
      attr_accessor :def
      attr_accessor :mat
      attr_accessor :mdf
      attr_accessor :agi
      attr_accessor :luk
       
      def initialize
        @mhp = 0
        @mmp = 0
        @atk = 0
        @def = 0
        @mat = 0
        @mdf = 0
        @agi = 0
        @luk = 0
      end
    end
     
    if CXJ::CLASS_EXTENSIONS::USE_PERSISTENT_CLASS_LEVEL
      #----------------------------------------------------------------------
      # * Alias: Setup
      #----------------------------------------------------------------------
      game_actor_setup_cxj_ce = instance_method(:setup)
      define_method :setup do |actor_id|
        game_actor_setup_cxj_ce.bind(self).call(actor_id)
        @exp = $game_persistent_class
        @exp[@class_id] = 0 if self.exp.nil?
      end
     
      #----------------------------------------------------------------------
      # * Override: Initialize Skills
      #----------------------------------------------------------------------
      def init_skills
        @skills = []
        $game_persistent_skills[0] = [] if $game_persistent_skills[0].nil?
        $game_persistent_skills[@class_id] = [] if $game_persistent_skills[@class_id].nil?
        self.class.learnings.each do |learning|
          learn_skill_persist(@class_id, learning.skill_id) if learning.level <= class_level(@class_id)
        end
        return if self.subclass.nil?
        $game_persistent_skills[@subclass_id] = [] if $game_persistent_skills[@subclass_id].nil?
        self.subclass.learnings.each do |learning|
          learn_skill_persist(@subclass_id, learning.skill_id) if learning.level <= class_level(@subclass_id)
        end
      end
   
      #----------------------------------------------------------------------
      # * Override: learn_class_skills
      #----------------------------------------------------------------------
      def learn_class_skills(class_id)
        return if class_id <= 0
        return if $data_classes[class_id].nil?
        $game_persistent_skills[@class_id] = [] if $game_persistent_skills[@class_id].nil?
        $data_classes[class_id].learnings.each do |learning|
          learn_skill_persist(class_id, learning.skill_id) if learning.level == class_level(class_id)
        end
      end
       
      #----------------------------------------------------------------------
      # * Override: Get Skill Object Array
      #----------------------------------------------------------------------
      def skills
        pers_all = (!$game_persistent_skills[0].nil? ? $game_persistent_skills[0] : [])
        pers_class = (!$game_persistent_skills[@class_id].nil? ? $game_persistent_skills[@class_id] : [])
        pers_subclass = (!$game_persistent_skills[@subclass_id].nil? ? $game_persistent_skills[@subclass_id] : [])
        (@skills | added_skills | pers_all | pers_class | pers_subclass).uniq.sort.collect {|id| $data_skills[id] }
      end
    end
 
    #----------------------------------------------------------------------
    # * New: Get Skill Object Array From Persistent Skills
    #----------------------------------------------------------------------
    def persistent_skills(class_id)
      persist = (!$game_persistent_skills[class_id].nil? ? $game_persistent_skills[class_id] : [])
      (persist).uniq.sort.collect {|id| $data_skills[id] }
    end
 
    #--------------------------------------------------------------------------
    # * New: Learn Skill (Persistent Class)
    #--------------------------------------------------------------------------
    def learn_skill_persist(class_id, skill_id)
      $game_persistent_skills[class_id] = [] if $game_persistent_skills[class_id].nil?
      unless skill_learn_persist?(class_id, $data_skills[skill_id])
        $game_persistent_skills[class_id].push(skill_id)
        $game_persistent_skills[class_id].sort!
      end
    end
    #--------------------------------------------------------------------------
    # * Forget Skill (Persistent Class)
    #--------------------------------------------------------------------------
    def forget_skill_persist(class_id, skill_id)
      $game_persistent_skills[class_id].delete(skill_id) if !$game_persistent_skills[class_id].nil?
    end
    #--------------------------------------------------------------------------
    # * Determine if Skill Is Already Learned (Persistent Class)
    #--------------------------------------------------------------------------
    def skill_learn_persist?(class_id, skill)
      skill.is_a?(RPG::Skill) && !$game_persistent_skills[class_id].nil? && $game_persistent_skills[class_id].include?(skill.id)
    end
 
    #------------------------------------------------------------------------
    # New: graphics_opt_in
    #------------------------------------------------------------------------
    def graphics_opt_in
      actor.graphics_opt_in
    end
    #------------------------------------------------------------------------
    # New: class_graphics
    #------------------------------------------------------------------------
    def class_graphics
      sub_id = @subclass_id ? @subclass_id : 0
      return nil if actor.class_graphics.nil? || actor.class_graphics[@class_id].nil?
      return actor.class_graphics[@class_id][sub_id] if CXJ::CLASS_EXTENSIONS::ENABLE_COMBO_SPECIFIC_GRAPHICS && !actor.class_graphics[@class_id][sub_id].nil?
      return actor.class_graphics[@class_id][0] if !actor.class_graphics[@class_id][0].nil?
      return nil
    end
    #------------------------------------------------------------------------
    # New: class_character_index
    #       Added for AnimEx compatibility
    #------------------------------------------------------------------------
    def class_character_index(d)
      cur_graph = class_graphics
      return nil if cur_graph.nil?
      index = cur_graph[:character_index]
      is_regular = cur_graph[:is_regular]
      has_diagonal = cur_graph[:has_diagonal]
      $imported["CXJ-AnimEx"] && is_regular && has_diagonal && d % 2 != 0 ? index + 1 : index
    end
    #------------------------------------------------------------------------
    # New: generic_class_graphics
    #------------------------------------------------------------------------
    def generic_class_graphics
      CXJ::CLASS_EXTENSIONS::GENERIC_CLASS_GRAPHICS[@generic_set]
    end
    #------------------------------------------------------------------------
    # New: default_generic_class_graphics
    #------------------------------------------------------------------------
    def default_generic_class_graphics
      CXJ::CLASS_EXTENSIONS::GENERIC_CLASS_GRAPHICS["DEFAULT"]
    end
    #------------------------------------------------------------------------
    # New: combo_class_graphics
    #------------------------------------------------------------------------
    def combo_class_graphics
      CXJ::CLASS_EXTENSIONS::COMBO_CLASS_GRAPHICS[@generic_set]
    end
    #------------------------------------------------------------------------
    # New: default_combo_class_graphics
    #------------------------------------------------------------------------
    def default_combo_class_graphics
      CXJ::CLASS_EXTENSIONS::COMBO_CLASS_GRAPHICS["DEFAULT"]
    end
    #------------------------------------------------------------------------
    # New: Get Graphics From Default
    #------------------------------------------------------------------------
    def get_graphics_from_default
      if CXJ::CLASS_EXTENSIONS::ENABLE_COMBO_SPECIFIC_GRAPHICS
        return combo_class_graphics[@class_id][@subclass_id] if !combo_class_graphics.nil? && !combo_class_graphics[@class_id].nil? && !combo_class_graphics[@class_id][@subclass_id].nil?
        return default_combo_class_graphics[@class_id][@subclass_id] if !default_combo_class_graphics.nil? && !default_combo_class_graphics[@class_id].nil? && !default_combo_class_graphics[@class_id][@subclass_id].nil?
      end
      return generic_class_graphics[@class_id] if !generic_class_graphics.nil? && !generic_class_graphics[@class_id].nil?
      return default_generic_class_graphics[@class_id] if !default_generic_class_graphics.nil? && !default_generic_class_graphics[@class_id].nil?
      return nil
    end
    #------------------------------------------------------------------------
    # New: generic_class_has_diagonal
    #------------------------------------------------------------------------
    def generic_class_has_diagonal
      CXJ::CLASS_EXTENSIONS::GENERIC_CLASS_HAS_DIAGONAL[@generic_set]
    end
    #------------------------------------------------------------------------
    # New: default_generic_class_has_diagonal
    #------------------------------------------------------------------------
    def default_generic_class_has_diagonal
      CXJ::CLASS_EXTENSIONS::GENERIC_CLASS_HAS_DIAGONAL["DEFAULT"]
    end
    #------------------------------------------------------------------------
    # New: combo_class_has_diagonal
    #------------------------------------------------------------------------
    def combo_class_has_diagonal
      CXJ::CLASS_EXTENSIONS::COMBO_CLASS_HAS_DIAGONAL[@generic_set]
    end
    #------------------------------------------------------------------------
    # New: default_combo_class_has_diagonal
    #------------------------------------------------------------------------
    def default_combo_class_has_diagonal
      CXJ::CLASS_EXTENSIONS::COMBO_CLASS_HAS_DIAGONAL["DEFAULT"]
    end
    #------------------------------------------------------------------------
    # New: Get Has Diagonal From Default
    #------------------------------------------------------------------------
    def get_has_diagonal_from_default
      if CXJ::CLASS_EXTENSIONS::ENABLE_COMBO_SPECIFIC_GRAPHICS
        return combo_class_has_diagonal[@class_id][@subclass_id] if !combo_class_has_diagonal.nil? && !combo_class_has_diagonal[@class_id].nil? && !combo_class_has_diagonal[@class_id][@subclass_id].nil?
        return default_combo_class_has_diagonal[@class_id][@subclass_id] if !default_combo_class_has_diagonal.nil? && !default_combo_class_has_diagonal[@class_id].nil? && !default_combo_class_has_diagonal[@class_id][@subclass_id].nil?
      end
      return generic_class_has_diagonal[@class_id] if !generic_class_has_diagonal.nil? && !generic_class_has_diagonal[@class_id].nil?
      return default_generic_class_has_diagonal[@class_id] if !default_generic_class_has_diagonal.nil? && !default_generic_class_has_diagonal[@class_id].nil?
      return false
    end
    #------------------------------------------------------------------------
    # New: character_name
    #------------------------------------------------------------------------
    def character_name
      if CXJ::CLASS_EXTENSIONS::ENABLE_CLASS_SPECIFIC_GRAPHICS
        if !class_graphics.nil?
          return class_graphics[:character_name] if !class_graphics[:character_name].nil?
        end
        if graphics_opt_in
          character = self.class.character(@subclass_id ? @subclass_id : 0)
          return character[:character_name] if !character.nil? && !character[:character_name].empty? && CXJ::CLASS_EXTENSIONS::CLASS_SPECIFIED_HAS_PRIORITY
          def_graph = get_graphics_from_default
          return def_graph[0] if !def_graph.nil? && !def_graph[0].empty?
          return character[:character_name] if !character.nil? && !character[:character_name].empty?
        end
      end
      @character_name
    end
    #------------------------------------------------------------------------
    # New: character_index
    #------------------------------------------------------------------------
    def character_index(d = 0, has_diagonal = false)
      if CXJ::CLASS_EXTENSIONS::ENABLE_CLASS_SPECIFIC_GRAPHICS
        if !class_graphics.nil?
          return class_character_index(d) if !class_graphics[:character_index].nil?
        end
        if graphics_opt_in
          character = self.class.character(@subclass_id ? @subclass_id : 0)
          return self.class.character_index(d, @subclass_id ? @subclass_id : 0) if !character.nil? && !character[:character_name].empty? && CXJ::CLASS_EXTENSIONS::CLASS_SPECIFIED_HAS_PRIORITY
          def_graph = get_graphics_from_default
          if !def_graph.nil? && !def_graph[0].empty?
            if $imported["CXJ-AnimEx"] && d % 2 != 0
              if def_graph[0] =~ /^\!?\[(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)(?:\s*,\s*(1|0))?\]/
                return def_graph[1] if([8, 9].include?($4.to_i))
              end
            end
            return def_graph[1] + (get_has_diagonal_from_default && d % 2 != 0 ? 1 : 0)
          end
          return self.class.character_index(d, @subclass_id ? @subclass_id : 0) if !character.nil? && !character[:character_name].empty?
        end
      end
      if @character_name =~ /^\!?\[(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)(?:\s*,\s*(1|0))?\]/
        if([8, 9].include?($4.to_i))
          return @character_index
        end
      end
      has_diagonal && d % 2 != 0 ? @character_index + 1 : @character_index
    end
    #------------------------------------------------------------------------
    # New: face_name
    #------------------------------------------------------------------------
    def face_name
      if CXJ::CLASS_EXTENSIONS::ENABLE_CLASS_SPECIFIC_GRAPHICS
        if !class_graphics.nil?
          return class_graphics[:face_name] if !class_graphics[:face_name].nil?
        end
        if graphics_opt_in
          face = self.class.face(@subclass_id ? @subclass_id : 0)
          return face[:face_name] if !face.nil? && !face[:face_name].empty? && CXJ::CLASS_EXTENSIONS::CLASS_SPECIFIED_HAS_PRIORITY
          def_graph = get_graphics_from_default
          return def_graph[2] if !def_graph.nil? && !def_graph[2].empty?
          return face[:face_name] if !face.nil? && !face[:face_name].empty?
        end
      end
      @face_name
    end
    #------------------------------------------------------------------------
    # New: face_index
    #------------------------------------------------------------------------
    def face_index
      if CXJ::CLASS_EXTENSIONS::ENABLE_CLASS_SPECIFIC_GRAPHICS
        if !class_graphics.nil?
          return class_graphics[:face_index] if !class_graphics[:face_index].nil?
        end
        if graphics_opt_in
          face = self.class.face(@subclass_id ? @subclass_id : 0)
          return face[:face_index] if !face.nil? && !face[:face_name].empty? && CXJ::CLASS_EXTENSIONS::CLASS_SPECIFIED_HAS_PRIORITY
          def_graph = get_graphics_from_default
          return def_graph[3] if !def_graph.nil? && !def_graph[2].empty?
          return face[:face_index] if !face.nil? && !face[:face_name].empty?
        end
      end
      @face_index
    end
    #------------------------------------------------------------------------
    # New: real_character_name
    #------------------------------------------------------------------------
    def real_character_name
      @character_name
    end
    #------------------------------------------------------------------------
    # New: real_character_index
    #------------------------------------------------------------------------
    def real_character_index
      @character_index
    end
    #------------------------------------------------------------------------
    # New: real_face_name
    #------------------------------------------------------------------------
    def real_face_name
      @face_name
    end
    #------------------------------------------------------------------------
    # New: real_face_index
    #------------------------------------------------------------------------
    def real_face_index
      @face_index
    end
    #--------------------------------------------------------------------------
    # * Alias: Get Base Value of Parameter
    #--------------------------------------------------------------------------
    game_actor_param_base_exp_cxj_ce = instance_method(:param_base)
    define_method :param_base do |param_id|
      use_class = CXJ::CLASS_EXTENSIONS::CLASS_LEVEL_PARAMS && !YEA::CLASS_SYSTEM::MAINTAIN_LEVELS
      use_regular = !CXJ::CLASS_EXTENSIONS::CLASS_LEVEL_PARAMS && YEA::CLASS_SYSTEM::MAINTAIN_LEVELS
      use_slev = (use_class ? class_level(@class_id) : @level)
      return game_actor_param_base_exp_cxj_ce.bind(self).call(param_id) if use_regular && CXJ::CLASS_EXTENSIONS::HYBRIDIZE == :none
      result = self.class.params[param_id, use_slev]
      unless subclass.nil?
        subclass_rate = YEA::CLASS_SYSTEM::SUBCLASS_STAT_RATE
        slevel = subclass_level
        chf = subclass.custom_hybrid_formula(param_id, @class_id)
        if !chf.nil?
          main = Game_Actor_Params.new
          sub = Game_Actor_Params.new
          main.mhp = self.class.params[0, use_slev] * 1.0
          main.mmp = self.class.params[1, use_slev] * 1.0
          main.atk = self.class.params[2, use_slev] * 1.0
          main.def = self.class.params[3, use_slev] * 1.0
          main.mat = self.class.params[4, use_slev] * 1.0
          main.mdf = self.class.params[5, use_slev] * 1.0
          main.agi = self.class.params[6, use_slev] * 1.0
          main.luk = self.class.params[7, use_slev] * 1.0
          sub.mhp = self.class.params[0, slevel] * 1.0
          sub.mmp = self.class.params[1, slevel] * 1.0
          sub.atk = self.class.params[2, slevel] * 1.0
          sub.def = self.class.params[3, slevel] * 1.0
          sub.mat = self.class.params[4, slevel] * 1.0
          sub.mdf = self.class.params[5, slevel] * 1.0
          sub.agi = self.class.params[6, slevel] * 1.0
          sub.luk = self.class.params[7, slevel] * 1.0
          result = eval(chf)
        else
          result*= (1 - subclass_rate) if CXJ::CLASS_EXTENSIONS::HYBRIDIZE == :ratio
          result += subclass.params[param_id, slevel] * subclass_rate
          result = result / (2.0) if CXJ::CLASS_EXTENSIONS::HYBRIDIZE == :add
          result = result / (1.0 + subclass_rate) if CXJ::CLASS_EXTENSIONS::HYBRIDIZE == :normalize
        end
      end
      return result.to_i
    end
     
    #------------------------------------------------------------------------
    # * Alias: Change Experience
    #     show : Level up display flag
    #------------------------------------------------------------------------
    game_actor_change_exp_cxj_ce = instance_method(:change_exp)
    define_method :change_exp do |exp, show|
      current_exp = (self.exp ? self.exp : 0)
      do_split = self.class.experience_split
      main_rate = self.class.experience_rate
      sub_ratio = (!subclass.nil? ? subclass.subclass_ratio : 0)
      sub_rate = (!subclass.nil? ? subclass.experience_rate : 0)
      main_exp = exp - current_exp
      main_exp*= [(1.00 - [0, sub_ratio].max), 0].max if do_split
      main_exp*= main_rate
      sub_exp = exp - current_exp
      sub_exp*= [0, sub_ratio].max if !do_split
      sub_exp*= [1.00, [0, sub_ratio].max].min if do_split
      sub_exp*= sub_rate
      @exp[:old] = current_exp
      @exp[:oldsub] = sub_exp
#      @exp[@subclass_id] = [@exp[@subclass_id] + sub_exp.to_i, 0].max if !subclass.nil?
      exp = main_exp.to_i + current_exp
      maxLevel = CXJ::CLASS_EXTENSIONS::DEFAULT_MAX_LEV
      maxLevel = self.class.max_level if self.class.max_level > -1
      maxExp = self.class.exp_for_level(maxLevel)
      last_level = @level
      last_mainskills = []
      last_classskills = []
      last_subskills = []
      if CXJ::CLASS_EXTENSIONS::USE_PERSISTENT_CLASS_LEVEL
        last_mainskills = persistent_skills(0) if !$game_persistent_skills[0].nil?
        last_classskills = persistent_skills(@class_id) if !$game_persistent_skills[@class_id].nil?
        last_subskills = persistent_skills(@subclass_id) if !self.subclass.nil? && !$game_persistent_skills[@subclass_id].nil?
      end
      if !CXJ::CLASS_EXTENSIONS::ENABLE_CLASS_LEVEL_LIMITER || YEA::CLASS_SYSTEM::MAINTAIN_LEVELS
        game_actor_change_exp_cxj_ce.bind(self).call(exp, show)
      elsif CXJ::CLASS_EXTENSIONS::STOP_GAINING_EXP_AFTER_MAX
        game_actor_change_exp_cxj_ce.bind(self).call([exp, maxExp].min, show)
      elsif CXJ::CLASS_EXTENSIONS::STOP_LEVELING_AFTER_CLASS_MAX
        @exp[@class_id] = [exp, 0].max
        last_skills = skills
        level_up while !max_level? && self.exp >= next_level_exp && self.exp <= maxExp
        level_down while self.exp < current_level_exp
        display_level_up(skills - last_skills) if show && @level > last_level
        refresh
      else
        game_actor_change_exp_cxj_ce.bind(self).call(exp, show)
      end
      if CXJ::CLASS_EXTENSIONS::USE_PERSISTENT_CLASS_LEVEL
        diff_mainskills = []
        diff_classskills = []
        diff_subskills = []
        diff_mainskills = persistent_skills(0) - last_mainskills if !$game_persistent_skills[0].nil?
        diff_classskills = persistent_skills(@class_id) - last_classskills if !$game_persistent_skills[@class_id].nil?
        diff_subskills = persistent_skills(@subclass_id) - last_subskills if !self.subclass.nil? && !$game_persistent_skills[@subclass_id].nil?
        display_level_up_persist(diff_mainskills, diff_classskills, diff_subskills, last_level) if show
      else
        display_class_update
      end
    end
    #--------------------------------------------------------------------------
    # * Override: Level Up
    #--------------------------------------------------------------------------
    def level_up
      @level += 1
      persist_class = CXJ::CLASS_EXTENSIONS::USE_PERSISTENT_CLASS_LEVEL
      maintain = YEA::CLASS_SYSTEM::MAINTAIN_LEVELS
      self.class.learnings.each do |learning|
        use_class = (learning.use_other ^ CXJ::CLASS_EXTENSIONS::SWITCH_MAIN_LEVEL)
        if ((maintain || !use_class) && learning.level == @level) || (!maintain && use_class && learning.level == class_level(@class_id))
          learn_skill(learning.skill_id) if !persist_class
          learn_skill_persist(@class_id, learning.skill_id) if persist_class
        end
      end
      $skill_class_unlock.each do |skill|
        skill_id = $data_skills.index(skill)
        next if skill_id.nil? || (!persist_class && skill_learn?(skill)) || (persist_class && skill_learn_persist?(0, skill))
        can_add = true
        skill.level_unlock.each do |class_id, level|
          if class_level(class_id) < level
            can_add = false
            break
          end
        end
        learn_skill(skill_id) if can_add && !persist_class
        learn_skill_persist(0, skill_id) if can_add && persist_class
      end
      return if(self.subclass.nil?)
      self.subclass.learnings.each do |learning|
        use_class = (learning.use_other ^ CXJ::CLASS_EXTENSIONS::SWITCH_MAIN_LEVEL)
        if ((maintain || !use_class) && learning.level == @level) || (!maintain && use_class && learning.level == class_level(@subclass_id))
          learn_skill(learning.skill_id) if !persist_class
          learn_skill_persist(@subclass_id, learning.skill_id) if persist_class
        end
      end
    end
    #------------------------------------------------------------------------
    # Override: New: class_level Edited by DisturbedInside
    #------------------------------------------------------------------------
    def class_level(class_id)
      return @level if YEA::CLASS_SYSTEM::MAINTAIN_LEVELS
      current_class = $data_classes[class_id]
      maxLevel = CXJ::CLASS_EXTENSIONS::DEFAULT_MAX_LEV
      maxLevel = current_class.max_level if current_class.max_level > -1
      maxLevel = max_level if !CXJ::CLASS_EXTENSIONS::ENABLE_CLASS_LEVEL_LIMITER
      maxExp = current_class.exp_for_level(maxLevel)
      @exp[class_id] = 0 if @exp[class_id].nil?
      n = 1
      loop do
        break if maxExp < current_class.exp_for_level(n + 1)
        break if @exp[class_id] < current_class.exp_for_level(n + 1)
        n+= 1
      end
      return n
    end
    #------------------------------------------------------------------------
    # * Alias: Get Array of All Objects Retaining Features
    #------------------------------------------------------------------------
    game_actor_feature_objects_cxj_ce = instance_method(:feature_objects)
    define_method :feature_objects do
      obj = game_actor_feature_objects_cxj_ce.bind(self).call
      obj+= [self.subclass] if !self.subclass.nil? && CXJ::CLASS_EXTENSIONS::SUBCLASS_TRAITS
      obj
    end
     
    #------------------------------------------------------------------------
    # * Override: Show Level Up Message
    #     new_skills : Array of newly learned skills
    #------------------------------------------------------------------------
    def display_level_up(new_skills)
      $game_message.new_page
      if CXJ::CLASS_EXTENSIONS::SHOW_CLASS_EXP_GAIN[:charlevel]
        $game_message.add(sprintf(Vocab::LevelUp, @name, Vocab::level, @level))
      else
        $game_message.add(sprintf(CXJ::CLASS_EXTENSIONS::VOCAB::CHARACTER_LEVELED_UP, @name))
      end
      return if CXJ::CLASS_EXTENSIONS::USE_PERSISTENT_CLASS_LEVEL
      new_skills.each do |skill|
        $game_message.add(sprintf(Vocab::ObtainSkill, skill.name))
      end
    end
    #------------------------------------------------------------------------
    # * New: Show Class Update
    #------------------------------------------------------------------------
    def display_class_update
      if CXJ::CLASS_EXTENSIONS::SHOW_CLASS_EXP_GAIN[:classexp]
        $game_message.add(sprintf(CXJ::CLASS_EXTENSIONS::VOCAB::CLASS_EXP_GAINED, @name, @exp[@class_id] - @exp[:old]))
      end
      if CXJ::CLASS_EXTENSIONS::SHOW_CLASS_EXP_GAIN[:classlevel]
        temp = @exp[@class_id]
        @exp[@class_id] = @exp[:old]
        old_level = class_level(@class_id)
        @exp[@class_id] = temp
        if old_level != class_level(@class_id)
          $game_message.add(sprintf(Vocab::LevelUp, self.class.name, Vocab::level, class_level(@class_id)))
        end
      end
      if !subclass.nil?
        if CXJ::CLASS_EXTENSIONS::SHOW_CLASS_EXP_GAIN[:classexp]
          $game_message.add(sprintf(CXJ::CLASS_EXTENSIONS::VOCAB::CLASS_EXP_GAINED, @name, @exp[@subclass_id] - @exp[:oldsub]))
        end
        if CXJ::CLASS_EXTENSIONS::SHOW_CLASS_EXP_GAIN[:classlevel]
          temp = @exp[@subclass_id]
          @exp[@subclass_id] = @exp[:oldsub]
          old_level = class_level(@subclass_id)
          @exp[@subclass_id] = temp
          if old_level != class_level(@subclass_id)
            $game_message.add(sprintf(Vocab::LevelUp, self.subclass.name, Vocab::level, class_level(@subclass_id)))
          end
        end
      end
    end
     
    #------------------------------------------------------------------------
    # * New: Show Level Up Message
    #     new_skills : Array of newly learned skills
    #------------------------------------------------------------------------
    def display_level_up_persist(new_skills, new_class, new_subclass, last_level)
      new_skills.each do |skill|
        $game_message.add(sprintf(Vocab::ObtainSkill, skill.name))
      end
      if CXJ::CLASS_EXTENSIONS::SHOW_CLASS_EXP_GAIN[:classexp]
        $game_message.add(sprintf(CXJ::CLASS_EXTENSIONS::VOCAB::CLASS_EXP_GAINED, @name, @exp[@class_id] - @exp[:old]))
      end
      if CXJ::CLASS_EXTENSIONS::SHOW_CLASS_EXP_GAIN[:classlevel]
        temp = @exp[@class_id]
        @exp[@class_id] = @exp[:old]
        old_level = class_level(@class_id)
        @exp[@class_id] = temp
        if old_level != class_level(@class_id)
          $game_message.add(sprintf(Vocab::LevelUp, self.class.name, Vocab::level, class_level(@class_id)))
        end
      end
      new_class.each do |skill|
        $game_message.add(sprintf(Vocab::ObtainSkill, skill.name))
      end
      if !subclass.nil?
        if CXJ::CLASS_EXTENSIONS::SHOW_CLASS_EXP_GAIN[:classexp]
          $game_message.add(sprintf(CXJ::CLASS_EXTENSIONS::VOCAB::CLASS_EXP_GAINED, @name, @exp[@subclass_id] - @exp[:oldsub]))
        end
        if CXJ::CLASS_EXTENSIONS::SHOW_CLASS_EXP_GAIN[:classlevel]
          temp = @exp[@subclass_id]
          @exp[@subclass_id] = @exp[:oldsub]
          old_level = class_level(@subclass_id)
          @exp[@subclass_id] = temp
          if old_level != class_level(@class_id)
            $game_message.add(sprintf(Vocab::LevelUp, self.subclass.name, Vocab::level, class_level(@subclass_id)))
          end
        end
        new_subclass.each do |skill|
          $game_message.add(sprintf(Vocab::ObtainSkill, skill.name))
        end
      end
    end
  end
 
  #============================================================================
  # ** Game_Player
  #----------------------------------------------------------------------------
  #  This class handles the player. It includes event starting determinants and
  # map scrolling functions. The instance of this class is referenced by
  # $game_player.
  #============================================================================
 
  class Game_Player < Game_Character
    #------------------------------------------------------------------------
    # * New: Refresh
    #------------------------------------------------------------------------
    def refresh
      @character_name = actor ? actor.real_character_name : ""
      @character_index = actor ? actor.real_character_index : 0
      @followers.refresh
    end
    #------------------------------------------------------------------------
    # New: character_name
    #------------------------------------------------------------------------
    def character_name
      if CXJ::CLASS_EXTENSIONS::ENABLE_CLASS_SPECIFIC_GRAPHICS
        cname = actor.character_name
        cind = actor.character_index(@direction)
        return cname if cname != actor.real_character_name || cind != actor.real_character_index
      end
      @character_name
    end
    #------------------------------------------------------------------------
    # New: character_index
    #------------------------------------------------------------------------
    def character_index
      if CXJ::CLASS_EXTENSIONS::ENABLE_CLASS_SPECIFIC_GRAPHICS
        cname = actor.character_name
        cind = actor.character_index(@direction)
        return cind if cname != actor.real_character_name || cind != actor.real_character_index
      end
      if $imported["CXJ-AnimEx"]
        super
      else
        @character_index
      end
    end
    #------------------------------------------------------------------------
    # New: face_name
    #------------------------------------------------------------------------
    def face_name
      if CXJ::CLASS_EXTENSIONS::ENABLE_CLASS_SPECIFIC_GRAPHICS
        fname = actor.face_name
        return fname if fname != actor.real_face_name || actor.face_index != actor.real_face_index
      end
      @face_name
    end
    #------------------------------------------------------------------------
    # New: face_index
    #------------------------------------------------------------------------
    def face_index
      if CXJ::CLASS_EXTENSIONS::ENABLE_CLASS_SPECIFIC_GRAPHICS
        fname = actor.face_name
        return actor.face_index if fname != actor.real_face_name || actor.face_index != actor.real_face_index
      end
      @face_index
    end
  end
 
  #============================================================================
  # ** Window_Base
  #----------------------------------------------------------------------------
  #  This is a super class of all windows within the game.
  #============================================================================
 
  class Window_Base < Window
   
    #------------------------------------------------------------------------
    # * Override: Draw Class
    #------------------------------------------------------------------------
    def draw_actor_class(actor, x, y, width = 112)
      change_color(normal_color)
      if actor.subclass.nil?
        text = actor.class.name
      elsif !actor.class.combined_name[actor.subclass_id].nil?
        text = actor.class.combined_name[actor.subclass_id]
      else
        fmt = YEA::CLASS_SYSTEM::SUBCLASS_TEXT
        text = sprintf(fmt, actor.class.name, actor.subclass.name)
      end
      draw_text(x, y, width, line_height, text)
    end
  end
 
  if $imported["YEA-ClassSpecifics"]
    #==========================================================================
    # ** Window_ClassList
    #--------------------------------------------------------------------------
    #  This class handles the class list window
    #==========================================================================
 
    class Window_ClassList < Window_Selectable
       
      #----------------------------------------------------------------------
      # Override: make_item_list
      #----------------------------------------------------------------------
      def make_item_list
        @data = []
        for class_id in YEA::CLASS_SYSTEM::CLASS_ORDER
          next if $data_classes[class_id].nil?
          item = $data_classes[class_id]
          next if CXJ::CLASS_EXTENSIONS::CLASS_HIDE_MODE == 1 && !available?(item)
          @data.push(item) if include?(item)
        end
      end
       
      #----------------------------------------------------------------------
      # New: Check if available
      #----------------------------------------------------------------------
      def available?(item)
        case @command_window.current_symbol
        when :primary
          return false if item.subclass_only
        when :subclass
          return false if item.primary_only
          return @actor.subclass_to?(item.id) if item.subclass_to != []
        end
        return true
      end
       
      #----------------------------------------------------------------------
      # Alias: set_item_colour
      #----------------------------------------------------------------------
      window_classlist_set_item_color = instance_method(:set_item_colour)
      define_method :set_item_colour do |item|
        if CXJ::CLASS_EXTENSIONS::CLASS_HIDE_MODE == 2
          primary_enable = (@command_window.current_symbol == :primary ? item == @actor.class : enable?(item))
          subclass_enable = (@command_window.current_symbol == :subclass ? item == @actor.subclass : enable?(item))
          if item == @actor.class
            change_color(text_color(YEA::CLASS_SYSTEM::CURRENT_CLASS_COLOUR), primary_enable)
          elsif item == @actor.subclass
            change_color(text_color(YEA::CLASS_SYSTEM::SUBCLASS_COLOUR), subclass_enable)
          else
            change_color(normal_color, enable?(item))
          end
        else
          window_classlist_set_item_color.bind(self).call(item)
        end
      end
    end
  end
   
  if $imported["YEA-LearnSkillEngine"]
    #==========================================================================
    # ** Window_LearnSkillList
    #==========================================================================
 
    class Window_LearnSkillList < Window_SkillList
      #----------------------------------------------------------------------
      # Alias: meet_requirements?
      #----------------------------------------------------------------------
      window_learnskilllist_meet_requirements_cxj_ce = instance_method(:meet_requirements?)
      define_method :meet_requirements? do |item|
        test = :meet?
        return false unless window_learnskilllist_meet_requirements_cxj_ce.bind(self).call(item)
        return false unless meet_class_level_requirements?(item)
        return true
      end
       
      #----------------------------------------------------------------------
      # New: meet_class_level_requirements?
      #----------------------------------------------------------------------
      def meet_class_level_requirements?(item)
        item.level_learn_unlock.each do |class_id, learn_level|
          return false if @actor.class_level(class_id) < learn_level
        end
        return true
      end
    end
  end
end