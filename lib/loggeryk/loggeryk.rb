module Loggeryk
  require 'logger'
  require 'fileutils'

  class Loggeryk
    LOG_FILE = 'logxtest.log'
    @log_file = nil
    @log_stdout = nil
    @format_obj = proc do |_, _, _, msg| "#{msg}\n" end
    @level_hs = {
      info: Logger::INFO,
      debug: Logger::DEBUG,
      warn: Logger::WARN,
      error: Logger::ERROR,
      fatal: Logger::FATAL,
      unknown: Logger::UNKNOWN
    }

    class << self
      def init(fname, stdout, level = :info)

        unless @log_file
          fname = nil if fname == false
          fname = LOG_FILE if fname == :default
          @log_file = Logger.new(fname) unless fname.nil?
          register_log_format(@log_file, @format_obj)
          register_log_level(@log_file, @level_hs[level])
        end

        unless @log_stdout
          @log_stdout = Logger.new($stdout) if stdout
          register_log_format(@log_stdout, @format_obj)
          register_log_level(@log_stdout, @level_hs[level])
        end
      end

      def register_log_format(log_obj, format_obj)
        log_obj&.formatter = format_obj
      end

      def register_log_level(log_obj, level)
        log_obj&.level = level
        #
        # Log4r互換インターフェイス
        # DEBUG < INFO < WARN < ERROR < FATAL < UNKNOWN
      end

      def block_call(block)
        return unless block.nil?

        value = block.call
        if value.instance_of(Array)
          value.join("\n")
        else
          value
        end
      end

      def error(str)
        @log_file&.error(str)
        @log_stdout&.error(str)
      end

      def error_b(&block)
        return unless block

        str = block_call(block)
        error(str) if str
      end

      def debug(str)
        @log_file&.debug(str)
        @log_stdout&.debug(str)
      end

      def debug_b(&block)
        return unless block

        str = block_call(block)
        debug(str) if str
      end

      def info(str)
        @log_file&.info(str)
        @log_stdout&.info(str)
      end

      def info_b(&block)
        return unless block

        str = block_call(block)
        debug(str) if str
      end

      def warn(str)
        @log_file&.warn(str)
        @log_stdout&.warn(str)
      end

      def warn_b(&block)
        return unless block

        str = block_call(block)
        warn(str) if str
      end

      def fatal(str)
        @log_file&.fatal(str)
        @log_stdout&.fatal(str)
      end

      def fatal_b(&block)
        return unless block

        str = block_call(block)
        fatal(str) if str
      end

      def close
        @log_file&.close
        @log_stdout&.close
      end
    end
    #  Loggeryk.init(:default, true, :unknown)
    #  Loggeryk.init(:default, true, :fatal)
    #  Loggeryk.init(:default, true, :error)
    #  Loggeryk.init(:default, true, :warn)
    #  Loggeryk.init(:default, true, :info)
    #  Loggeryk.init(:default, true, :debug)
      Loggeryk.init(File.join(ENV['PWD'], 'log2.log'), true, :debug)
    #  Loggeryk.init(:default, false, :debug)
    Loggeryk.debug("PWD=#{ENV['PWD']}")
  end
end
