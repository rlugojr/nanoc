module Nanoc::Int
  # @api private
  class OutdatednessStatus
    attr_reader :reasons
    attr_reader :props

    def initialize(reasons: [], props: Props.new)
      @reasons = reasons
      @props = props
    end

    def useful_to_apply?(rule)
      (rule.instance.reason.props.active - @props.active).any?
    end

    def update(reason)
      self.class.new(
        reasons: @reasons + [reason],
        props: @props.merge(reason.props),
      )
    end
  end
end
