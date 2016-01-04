# rubocop:disable all
module PrivatePlease
  module Debug
    def self.log_to_trace_file(tpd)
      TRACES_LINES.puts TracePointDataLogger.format(tpd)
    end

    def self.enabled?
      defined?(TRACES_LINES)
    end

    module TracePointDataLogger
      MARKERS = {
        call: '-->',
        line: "\n l "
      }.freeze

      def self.format(cur_tpd)
        class_and_method = cur_tpd.method_full_name
        if @prev_cur_tpd.nil?
          same_object_id = same_lineno = false
        else
          same_object_id = @prev_cur_tpd.object_id == cur_tpd.object_id
          same_lineno = @prev_cur_tpd.lineno == cur_tpd.lineno
          same_code = @prev_cur_tpd.code == cur_tpd.code
          same_class_and_method = @prev_class_and_method == class_and_method
          same_self = @prev_self == cur_tpd._self
          same_defined_class = @prev_defined_class == cur_tpd.defined_class
        end

        @prev_cur_tpd = cur_tpd
        @prev_class_and_method = class_and_method
        @prev_self = cur_tpd._self
        @prev_defined_class = cur_tpd.defined_class

        data = {
          marker: MARKERS[cur_tpd.event],
          lineno: same_lineno ? '==' : cur_tpd.lineno,
          event: cur_tpd.event,
          object_id: same_object_id ? '==' : cur_tpd.object_id,
          code: same_code ? '"' : cur_tpd.code,
          class_and_method: same_class_and_method ? '""' : class_and_method,
          _self: same_self ? '=' : cur_tpd._self,
          defined_class: same_defined_class ? '=' : cur_tpd.defined_class
        }
        text_line(data)
      end

      def self.header
        text_line(
          marker: '',
          lineno: 'LINE',
          event: 'EVENT',
          object_id: 'OBJECT_ID',
          code: 'CODE',
          class_and_method: 'method_as_key',
          _self: '_self',
          defined_class: 'defined_class'
        )
      end

      def self.text_line(data)
        zelf = begin
                 data[:_self].to_s
               rescue
                 'RESCUED:' + data[:_self].inspect
               end
        '%3s %4s :%10s | %14s | %-80s | %-60s > %s' % [
          data[:marker],
          data[:lineno],
          data[:event],
          data[:object_id],
          data[:code],
          data[:class_and_method],
          [zelf, data[:defined_class]].join('/')
        ]
      end
    end
  end
end
# rubocop:enable all
