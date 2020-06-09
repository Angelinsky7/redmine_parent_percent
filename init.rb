# SettingsHelper.prepend(RedmineParentPercent::SettingsHelperPatch)
SettingsHelper.send(:include, RedmineParentPercent::SettingsHelperPatch)
# Issue.prepend(RedmineParentPercent::IssuePatch)
Issue.send(:include, RedmineParentPercent::IssuePatch)

Redmine::Plugin.register :redmine_parent_percent do
  name 'Parent Task Percentage Methods'
  author 'Angelinsky7'
  description 'Percentage of parent task new methods'
  version '0.0.1'
  url 'https://github.com/Angelinsky7/redmine_parent_percent.git'
  author_url 'https://github.com/Angelinsky7/redmine_parent_percent.git'

end
