# encoding: utf-8

class Nanoc::Extra::Checking::Checkers::StaleTest < MiniTest::Unit::TestCase

  include Nanoc::TestHelpers

  def checker_class
    Nanoc::Extra::Checking::Checkers::Stale
  end

  def calc_issues
    site = Nanoc::Site.new('.')
    checker = checker_class.new(site)
    checker.run
    checker.issues
  end

  def test_run_ok
    with_site do |site|
      assert Dir['content/*'].empty?
      assert Dir['output/*'].empty?

      # Empty
      FileUtils.mkdir_p('output')
      assert self.calc_issues.empty?

      # One OK file
      File.open('content/index.html', 'w') { |io| io.write('stuff') }
      File.open('output/index.html', 'w') { |io| io.write('stuff') }
      assert self.calc_issues.empty?
    end
  end

  def test_run_error
    with_site do |site|
      assert Dir['content/*'].empty?
      assert Dir['output/*'].empty?

      File.open('content/index.html', 'w') { |io| io.write('stuff') }
      File.open('output/WRONG.html', 'w') { |io| io.write('stuff') }
      assert_equal 1, self.calc_issues.count
      issue = self.calc_issues.to_a[0]
      assert_equal "file without matching item", issue.description
      assert_equal "output/WRONG.html", issue.subject
    end
  end

end

