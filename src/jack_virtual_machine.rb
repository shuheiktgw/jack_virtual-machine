require_relative './recorder/assembly_recorder'
require_relative './translator/vm_translator'
require_relative './dispatcher/vm_dispatcher'
require_relative './vm_loader'

class JackVirtualMachine

  attr_reader :file_path

  def initialize(file_path)
    @file_path = file_path
  end

  def run
    loader.execute
  end

  def asm_file_path
    recorder.asm_file_path
  end

  private

  def translator
    @translator ||= Translator::VmTranslator.new
  end

  def recorder
    # Prevent deleting asm file when calling asm_file_path
    @recorder ||= Recorder::AssemblyRecorder.new(file_path, translator)
  end

  def dispatcher
    Dispatcher::VmDispatcher.new(translator, recorder)
  end

  def loader
    VmLoader.new(file_path, dispatcher, translator)
  end
end