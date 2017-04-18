require 'redmine'
require 'redcarpet'

RepositoriesController.class_eval do
  class CodeRayHTML < Redcarpet::Render::HTML
    def block_code(code, language)
      CodeRay.scan(code.force_encoding('utf-8'), language || 'md').div
    end
  end

  alias markdown_extra_viewer_orig_entry entry
  def entry
    markdown_extra_viewer_orig_entry
    if not performed? and @path =~ /\.(md|markdown)\z/
      markdown = Redcarpet::Markdown.new(
        CodeRayHTML.new(
          :filter_html => true,
          :hard_wrap => true
        ),
        :autolink => true,
        :fenced_code_blocks => true,
        :space_after_headers => true,
        :tables => true,
        :strikethrough => true,
        :superscript => true,
        :no_intra_emphasis => true
      )
      @content = markdown.render(@content)
      render :template => "repositories/entry_markdown"
    end
  end
end

Redmine::Plugin.register :redmine_markdown_extra_viewer do
  name 'Redmine Markdown Extra Viewer plugin'
  author 'TOMITA Masahiro'
  description 'Redmine show Markdown Extra in repository'
  version '0.0.1'
  url 'http://github.com/tmtm/redmine_markdown_extra_viewer'
  author_url 'http://github.com/tmtm'
end


