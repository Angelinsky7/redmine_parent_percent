require_dependency "issue"

module RedmineParentPercent
  module IssuePatch
    def self.included(base)
      base.class_eval do

        def done_ratio_with_redmine_parent_percent
          result = done_ratio_without_redmine_parent_percent
          if done_ratio_calculed_done_on_total?
            result = calculate_ratio_done_on_total(self.id)
          end
          result
        end
        alias_method :done_ratio_without_redmine_parent_percent, :done_ratio
        alias_method :done_ratio, :done_ratio_with_redmine_parent_percent

        def done_ratio_calculed_done_on_total?
          self.children? && Setting.parent_issue_done_ratio == 'calc_done_on_total'
        end

        def calculate_ratio_done_on_total(issue_id)
          result = 0

          if issue_id && p = Issue.find_by_id(issue_id)
            children = p.children.to_a
            if children.any?
              child_done = children.count {|c| c.closed?}
              progress = 100 * child_done / children.count
              result = progress.round
            end
          end

          result
        end

        def recalculate_attributes_for_with_redmine_parent_percent(issue_id)
          recalculate_attributes_for_without_redmine_parent_percent(issue_id)

          if issue_id && p = Issue.find_by_id(issue_id)
            if p.priority_derived?
              if p.done_ratio_calculed_done_on_total?
                p.done_ratio = calculate_ratio_done_on_total(issue_id)
                p.save(:validate => false)
              end
            end
          end

        end
        alias_method :recalculate_attributes_for_without_redmine_parent_percent, :recalculate_attributes_for
        alias_method :recalculate_attributes_for, :recalculate_attributes_for_with_redmine_parent_percent
  
      end
    end
  end
end