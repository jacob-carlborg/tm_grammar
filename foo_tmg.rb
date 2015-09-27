grammar 'source.d' do
  comment 'D language'
  file_types %w(d di)
  key_equivalent '^~D'
  name 'D'
  uuid 'D7C3A109-0466-4C28-9ECF-10753300FF46'
  first_line_match '^#!.*\bg?dmd\b.'

  pattern 'comment.block.empty.d' do
    match '/\*\*/'
    capture 0, 'punctuation.definition.comment.d'
  end

  pattern { include 'text.html.javadoc' }

  pattern 'meta.other.debug.d' do
    match '\s*(\b(deprecated|unittest|debug)\b|((static)\s+)?(assert))'

    capture 2, 'keyword.other.debug.d'
    capture 4, 'keyword.other.debug.d'
    capture 5, 'keyword.other.debug.d'
  end

  pattern 'meta.version.d' do
    match '(?x)^\s*
					(else\s+)?(version)\s*
					\(\s*
					((DigitalMars|
					GNU|
					LDC|
					SDC|
					Windows|
					Win32|
					Win64|
					linux|
					OSX|
					FreeBSD|
					OpenBSD|
					NetBSD|
					DragonFlyBSD|
					BSD|
					Solaris|
					Posix|
					AIX|
					Haiku|
					SkyOS|
					SysV3|
					SysV4|
					Hurd|
					Android|
					Cygwin|
					MinGW|
					FreeStanding|
					X86|
					X86_64|
					ARM|
					ARM_Thumb|
					ARM_SoftFloat|
					ARM_SoftFP|
					ARM_HardFloat|
					AArch64|
					Epiphany|
					PPC|
					PPC_SoftFloat|
					PPC_HardFloat|
					PPC64|
					IA64|
					MIPS32|
					MIPS64|
					MIPS_O32|
					MIPS_N32|
					MIPS_O64|
					MIPS_N64|
					MIPS_EABI|
					MIPS_SoftFloat|
					MIPS_HardFloat|
					NVPTX|
					NVPTX64|
					SPARC|
					SPARC_V8Plus|
					SPARC_SoftFloat|
					SPARC_HardFloat|
					SPARC64|
					S390|
					S390X|
					HPPA|
					HPPA64|
					SH|
					SH64|
					Alpha|
					Alpha_SoftFloat|
					Alpha_HardFloat|
					LittleEndian|
					BigEndian|
					D_Coverage|
					D_Ddoc|
					D_InlineAsm_X86|
					D_InlineAsm_X86_64|
					D_LP64|
					D_X32|
					D_HardFloat|
					D_SoftFloat|
					D_PIC|
					D_SIMD|
					D_Version2|
					D_NoBoundsChecks|
					unittest|
					assert|
					none|
					all)|(darwin|Thumb)|([A-Za-z_][A-Za-z0-9_]*))
					\s*\)'

    capture 1, 'keyword.control.version.d'
    capture 2, 'keyword.control.version.d'
    capture 4, 'constant.language.version.d'
    capture 5, 'invalid.deprecated.version.d'
  end

  pattern 'meta.control.conditional.d' do
    match '\s*\b((else|switch)|((static)\s+)?(if))\b'

    capture 2, 'keyword.control.conditional.d'
    capture 4, 'keyword.control.conditional.d'
    capture 5, 'keyword.control.conditional.d'
  end

  pattern 'meta.definition.class.d' do
    self.begin '(?x)^\s*
					((?:\b(public|private|protected|static|final|synchronized|abstract|export|shared)\b\s*)*) # modifier
					(class|interface)\s+
					(\w+)\s* # identifier
					(?:\(\s*([^\)]+)\s*\)|)\s* # Template type
					(?:
					  \s*(:)\s*
					  (\w+)
					  (?:\s*,\s*(\w+))?
					  (?:\s*,\s*(\w+))?
					  (?:\s*,\s*(\w+))?
					  (?:\s*,\s*(\w+))?
					  (?:\s*,\s*(\w+))?
					  (?:\s*,\s*(\w+))?
					)? # super class
					'
    self.end '(?={|;)'

    begin_capture 1, 'storage.modifier.d'
    begin_capture 3, 'storage.type.structure.d'
    begin_capture 4, 'entity.name.type.class.d'

    begin_capture 5 do
      pattern { include '$base' }
    end

    begin_capture 6, 'punctuation.separator.inheritance.d'
    begin_capture 7, 'entity.other.inherited-class.d'
    begin_capture 8, 'entity.other.inherited-class.d'
    begin_capture 9, 'entity.other.inherited-class.d'
    begin_capture 10, 'entity.other.inherited-class.d'
    begin_capture 11, 'entity.other.inherited-class.d'
    begin_capture 12, 'entity.other.inherited-class.d'
    begin_capture 13, 'entity.other.inherited-class.d'


    pattern 'meta.definition.class.extends.d' do
      self.begin '\b(_|:)\b';
      self.end '(?={)';

      capture 1, 'storage.modifier.d'
      pattern { include '#all-types' }
    end

    pattern { include '#template-constraint-d' }
  end

  pattern 'meta.definition.struct.d' do
    self.begin '(?x)^\s*
					((?:\b(public|private|protected|static|final|synchronized|abstract|export|shared)\b\s*)*) # modifier
					(struct)\s+
					(\w+)\s* # identifier
					(?:\(\s*([^\)]+)\s*\)|)\s* # Template type
					'

    self.end '(?={|;)'

		begin_capture 1, 'storage.modifier.d'
		begin_capture 3, 'storage.type.structure.d'
		begin_capture 4, 'entity.name.type.struct.d'

    begin_capture 5 do
      pattern { include '$base' }
    end

    pattern 'meta.definition.class.extends.d' do
      self.begin '\b(_|:)\b'
      self.end '(?={)'
      capture 1, 'storage.modifier.d'
      pattern { include '#all-types' }
    end

    pattern { include '#template-constraint-d' }
  end

  pattern 'meta.definition.constructor.d' do
    self.begin '(?x)^\s*
					((?:\b(public|private|protected|static|final|synchronized|abstract|export)\b\s*)*) # modifier
					(\b(this))\s* # identifier
					(?=\()'

    self.end '(?={|;)'

    capture 1, 'storage.modifier.d'
    capture 3, 'entity.name.function.constructor.d'

    pattern { include '$base'}
  end

  pattern 'meta.definition.destructor.d' do
    self.begin '(?x)
    				(?:  ^                                 # begin-of-line
    				  |  (?: (?<!else|new|=) )             #  or word + space before name
    				)
					((?:\b(?:public|private|protected|static|final|synchronized|abstract|export)\b\s*)*) # modifier
    				(~this) # actual name
    				 \s*(\()                           # start bracket or end-of-line
    			'
    self.end '\)'

    capture 1, 'storage.modifier.d'
    capture 2, 'entity.name.function.destructor.d'

    end_capture 0, 'punctuation.definition.parameters.d'
    pattern { include '$base' }
  end

  pattern 'meta.definition.method.d' do
    self.begin '(?x)^\s*
					((?:\b(?:public|private|protected|static|final|synchronized|abstract|export|override|auto|nothrow|immutable|const|inout|ref|shared)\b\s*)*) # modifier
					(?:(_|\w[^\s]*))\s+ # return type
					(\w+)\s* # identifier
					(?=\()'

    self.end '(?={|;)'

		begin_capture 1, 'storage.modifier.d'

    begin_capture 2 do
      pattern { include '$base' }
    end

		begin_capture 3, 'entity.name.function.d'

    pattern { include '$base' }
    pattern { include '#block' }
  end

  pattern 'meta.traits.d' do
    self.begin '(?x)^\s*
					(__traits)
					\(
					(isAbstractClass|
					isArithmetic|
					isAssociativeArray|
					isFinalClass|
					isPOD|
					isNested|
					isFloating|
					isIntegral|
					isScalar|
					isStaticArray|
					isUnsigned|
					isVirtualFunction|
					isVirtualMethod|
					isAbstractFunction|
					isFinalFunction|
					isStaticFunction|
					isOverrideFunction|
					isRef|
					isOut|
					isLazy|
					hasMember|
					identifier|
					getAliasThis|
					getAttributes|
					getFunctionAttributes|
					getMember|
					getOverloads|
					getPointerBitmap|
					getProtection|
					getVirtualFunctions|
					getVirtualMethods|
					getUnitTests|
					parent|
					classInstanceSize|
					getVirtualIndex|
					allMembers|
					derivedMembers|
					isSame|
					compiles)
					,'

    self.end '\);'

		begin_capture 1, 'keyword.other.special.d'
		begin_capture 2, 'constant.language.traits.d'

    pattern { include '$base' }
  end

  pattern 'meta.external.d' do
    match '(extern)(\s*\(\s*(((C\+\+)(\s*,\s*[A-Za-z_][A-Za-z0-9._]*)?)|(C|D|Windows|Pascal|System))\s*\))?'

    capture 1, 'keyword.other.external.d'
    capture 5, 'constant.language.external.d'
    capture 7, 'constant.language.external.d'
  end

  pattern 'constant.other.d' do
    match '\b([A-Z][A-Z0-9_]+)\b'
  end

  pattern { include '#comments' }
  pattern { include '#all-types' }

  pattern 'storage.modifier.access-control.d' do
    match '\b(private|protected|public|export|package)\b'
  end

  pattern 'storage.modifier.d' do
    match '(?x)
				\b(
					auto|
					static|
					override|
					final|
					abstract|
					volatile|
					synchronized|
					lazy|
					nothrow|
					immutable|
					const|
					inout|
					ref|
					in|
					scope|
					__gshared|
					shared|
					pure
				)
				\b|
				(@)(
					property|
					disable|
					nogc|
					safe|
					trusted|
					system
				)\b'
  end

  pattern 'storage.type.structure.d' do
    match '\b(template|interface|class|enum|struct|union)\b'
  end

  pattern 'storage.type.d' do
    match '(?x)
				\b(
					ushort|
					int|
					uint|
					long|
					ulong|
					float|
					void|
					byte|
					ubyte|
					double|
					char|
					wchar|
					ucent|
					cent|
					short|
					bool|
					dchar|
					real|
					ireal|
					ifloat|
					idouble|
					creal|
					cfloat|
					cdouble|
					lazy|
					__vector
				)\b'
  end

  pattern('keyword.control.exception.d') { match '\b(try|catch|finally|throw)\b' }
  pattern('keyword.control.d') { match '\b(return|break|case|continue|default|do|while|for|switch|if|else)\b' }
  pattern('keyword.control.branch.d') { match '\b(goto|break|continue)\b' }
  pattern('keyword.control.repeat.d') { match '\b(while|for|do|foreach(_reverse)?)\b' }
  pattern('keyword.control.statement.d') { match '\b(return|with|invariant|body|scope|asm|mixin|function|delegate)\b' }
  pattern('keyword.control.pragma.d') { match '\b(pragma)\b' }
  pattern('keyword.control.alias.d') { match '\b(alias|typedef)\b' }
  pattern('keyword.control.import.d') { match '\b(import)\b' }

  pattern 'meta.module.d' do
    match '^\s*(module)\s+([^ ;]+?);'

		capture 1, 'keyword.control.module.d'
		capture 2, 'entity.name.function.package.d'
  end

  pattern('constant.language.boolean.d') { match '\b(true|false)\b' }

  pattern 'constant.language.d' do
    match '(?x)
				\b(
					__FILE__|
					__LINE__|
					__DATE__|
					__TIME__|
					__TIMESTAMP__|
					__MODULE__|
					__FUNCTION__|
					__PRETTY_FUNCTION__|
					__VENDOR__|
					__VERSION__|
					null
				)\b'
  end

  pattern('variable.language.d') { match '\b(this|super)\b' }
  pattern('constant.numeric.d') { match '\b((0(x|X)[0-9a-fA-F]*)|(([0-9]+\.?[0-9]*)|(\.[0-9]+))((e|E)(\+|-)?[0-9]+)?)([LlFfUuDd]|UL|ul)?\b' }

  pattern { include '#string_escaped_char' }
	pattern {	include '#strings' }

  pattern('keyword.operator.comparison.d') { match '(==|!=|<=|>=|<>|<|>)' }
  pattern('keyword.operator.increment-decrement.d') { match '(\-\-|\+\+)' }
  pattern('keyword.operator.arithmetic.d') { match '(\-|\+|\*|\/|~|%|\^|\^\^)=?' }
  pattern('keyword.operator.slice.d') { match '(\.\.)' }
  pattern('keyword.operator.logical.d') { match '(!|&&|\|\|)' }

  pattern 'keyword.operator.overload.d' do
    match '(?x)
				\b(
					opNeg|
					opCom|
					opPostInc|
					opPostDec|
					opCast|
					opAdd|
					opSub|
					opSub_r|
					opMul|
					opDiv|
					opDiv_r|
					opMod|
					opMod_r|
					opAnd|
					opOr|
					opXor|
					opShl|
					opShl_r|
					opShr|
					opShr_r|
					opUShr|
					opUShr_r|
					opCat|
					opCat_r|
					opEquals|
					opEquals|
					opCmp|
					opCmp|
					opCmp|
					opCmp|
					opAddAssign|
					opSubAssign|
					opMulAssign|
					opDivAssign|
					opModAssign|
					opAndAssign|
					opOrAssign|
					opXorAssign|
					opShlAssign|
					opShrAssign|
					opUShrAssign|
					opCatAssign|
					opIndex|
					opIndexAssign|
					opCall|
					opSlice|
					opSliceAssign|
					opPos|
					opAdd_r|
					opMul_r|
					opAnd_r|
					opOr_r|
					opXor_r|
					opDispatch
				)\b'
  end

  pattern('keyword.operator.d') { match '\b(new|delete|typeof|typeid|cast|align|is)\b' }
  pattern('keyword.other.class-fns.d') { match '\b(new)\b' }
  pattern('keyword.other.special.d') { match '\b(__parameters)\b|(#)line\b' }
  pattern('keyword.other.reserved.d') { match '\b(macro)\b' }

  pattern 'support.type.sys-types.c' do
    match '(?x)
				\b(
					u_char|
					u_short|
					u_int|
					u_long|
					ushort|
					uint|
					u_quad_t|
					quad_t|
					qaddr_t|
					caddr_t|
					daddr_t|
					dev_t|
					fixpt_t|
					blkcnt_t|
					blksize_t|
					gid_t|
					in_addr_t|
					in_port_t|
					ino_t|
					key_t|
					mode_t|
					nlink_t|
					id_t|
					pid_t|
					off_t|
					segsz_t|
					swblk_t|
					uid_t|
					id_t|
					clock_t|
					size_t|
					ssize_t|
					time_t|
					useconds_t|
					suseconds_t
				)\b'
  end

  pattern 'support.type.pthread.c' do
    match '(?x)
				\b(
					pthread_attr_t|
					pthread_cond_t|
					pthread_condattr_t|
					pthread_mutex_t|
					pthread_mutexattr_t|
					pthread_once_t|
					pthread_rwlock_t|
					pthread_rwlockattr_t|
					pthread_t|
					pthread_key_t
				)\b'
  end

  pattern 'support.type.stdint.c' do
    match '(?x)
				\b(
					int8_t|
					int16_t|
					int32_t|
					int64_t|
					uint8_t|
					uint16_t|
					uint32_t|
					uint64_t|
					int_least8_t|
					int_least16_t|
					int_least32_t|
					int_least64_t|
					uint_least8_t|
					uint_least16_t|
					uint_least32_t|
					uint_least64_t|
					int_fast8_t|
					int_fast16_t|
					int_fast32_t|
					int_fast64_t|
					uint_fast8_t|
					uint_fast16_t|
					uint_fast32_t|
					uint_fast64_t|
					intptr_t|
					uintptr_t|
					intmax_t|
					intmax_t|
					uintmax_t|
					uintmax_t
				)\b'
  end

  pattern { include '#block' }

  rule 'all-types' do
    pattern { include '#support-type-built-ins-d' }
    pattern { include '#support-type-d' }
    pattern { include '#storage-type-d' }
  end

  rule 'block' do
    pattern 'meta.block.d' do
      self.begin '\{'
      self.end '\}'

      begin_capture 0, 'punctuation.section.block.begin.d'
      end_capture 0, 'punctuation.section.block.end.d'

      pattern { include '$base' }
    end
  end

  rule 'comments' do
    pattern 'comment.block.d' do
      self.begin '/\*'
      self.end '\*/'

      capture 0, 'punctuation.definition.comment.d'
    end

    pattern 'comment.block.nested.d' do
      self.begin '/\+'
      self.end '\+/'

      capture 0, 'punctuation.definition.comment.d'
    end

    pattern do
      self.begin '(^[ \t]+)?(?=//)'
      self.end '(?!\G)'

      begin_capture 1, 'punctuation.whitespace.comment.leading.d'

      pattern 'comment.line.double-slash.d' do
        self.begin '//'
        self.end '\n'

        begin_capture 0, 'punctuation.definition.comment.d'
      end
    end
  end

  rule 'constant_placeholder' do
    name 'constant.other.placeholder.d'
    match '(?i:%(\([a-z_]+\))?#?0?\-?[ ]?\+?([0-9]*|\*)(\.([0-9]*|\*))?[hL]?[a-z%])'
  end

  rule 'regular_expressions' do
    disabled true
    comment 'Change disabled to 1 to turn off syntax highlighting in “r” strings.'

    pattern { include 'source.regexp.python' }
  end

  rule 'statement-remainder' do
    pattern 'meta.definition.param-list.d' do
      self.begin '\('
      self.end '(?=\))'
      pattern { include '#all-types' }
    end
  end

  rule 'storage-type-d' do
    name 'storage.type.d'
    match '\b(void|byte|short|char|int|long|float|double)\b'
  end

  rule 'string_escaped_char' do
    pattern('constant.character.escape.d') { match /\\(\\|[abefnprtv'"?]|[0-3]\d{0,2}|x[0-9a-fA-F]{2}|u[0-9a-fA-F]{4}|U[0-9a-fA-F]{8}|&\w+;)/ }
    pattern('invalid.illegal.unknown-escape.d') { match /\\./ }
  end

  rule 'strings' do
    pattern 'string.quoted.double.d' do
      self.begin '"'
      self.end '"'

      begin_capture 0, 'punctuation.definition.string.begin.d'
      end_capture 0, 'punctuation.definition.string.end.d'

      pattern { include '#string_escaped_char' }
    end

    pattern 'string.quoted.double.raw.d' do
      self.begin '(r)(")'
      self.end '((?<=")(")|")'

			begin_capture 1, 'storage.type.string.d'
			begin_capture 2, 'punctuation.definition.string.begin.d'

			end_capture 1, 'punctuation.definition.string.end.d'
			end_capture 2, 'meta.empty-string.double.d'

      pattern { include '#regular_expressions' }
    end

    pattern 'string.quoted.double.raw.backtick.d' do
      self.begin '`'
      self.end '((?<=`)(`)|`)'

      begin_capture 0, 'punctuation.definition.string.begin.d'

			end_capture 1, 'punctuation.definition.string.end.d'
			end_capture 2, 'meta.empty-string.double.d'
    end

    pattern 'string.quoted.single.d' do
      self.begin "'"
      self.end "'"

      begin_capture 0, 'punctuation.definition.string.begin.d'
      end_capture 0, 'punctuation.definition.string.end.d'

      pattern { include '#string_escaped_char' }
    end
  end

  rule 'support-type-built-ins-aliases-d' do
    name 'support.type.built-ins.aliases.d'
    match '\b(dstring|equals_t|hash_t|ptrdiff_t|sizediff_t|size_t|string|wstring)\b'
  end

  rule 'support-type-built-ins-classes-d' do
    name 'support.type.built-ins.classes.d'
    match '(?x)
				\b(
					AbstractServer|
					ArchiveMember|
					ArgParser|
					Barrier|
					BomSniffer|
					Buffer|
					BufferInput|
					BufferOutput|
					BufferSlice|
					BufferedFile|
					BufferedStream|
					BzipInput|
					BzipOutput|
					CFile|
					CacheInvalidatee|
					CacheInvalidator|
					CacheServer|
					CacheThread|
					Certificate|
					CertificateStore|
					CertificateStoreCtx|
					ChunkInput|
					ChunkOutput|
					ClassInfo|
					Cluster|
					ClusterCache|
					ClusterQueue|
					ClusterThread|
					CmdParser|
					ComObject|
					Compress|
					Condition|
					Conduit|
					Cookie|
					CookieParser|
					CookieStack|
					CounterInput|
					CounterOutput|
					DataFileInput|
					DataFileOutput|
					DataInput|
					DataOutput|
					Database|
					DatagramConduit|
					DeviceConduit|
					DigestInput|
					DigestOutput|
					DocPrinter|
					Document|
					DummyInputStream|
					DummyOutputStream|
					EndianInput|
					EndianOutput|
					EndianProtocol|
					EndianStream|
					EventSeekInputStream|
					EventSeekOutputStream|
					FTPConnection|
					Fiber|
					Field|
					File|
					FileConduit|
					FileFolder|
					FileGroup|
					FileInput|
					FileOutput|
					FilePath|
					FileScan|
					FilterStream|
					Foo|
					FormatOutput|
					GreedyInput|
					GreedyOutput|
					Gregorian|
					GrowBuffer|
					HeapCopy|
					HeapSlice|
					Hierarchy|
					HttpClient|
					HttpCookies|
					HttpCookiesView|
					HttpGet|
					HttpHeaders|
					HttpHeadersView|
					HttpParams|
					HttpPost|
					HttpStack|
					HttpTokens|
					HttpTriplet|
					IPv4Address|
					IUnknown|
					InputFilter|
					InternetAddress|
					InternetHost|
					Layout|
					LineInput|
					LineIterator|
					LinkedFolder|
					Log|
					MapInput|
					MapOutput|
					MappedBuffer|
					Md2|
					Md4|
					MemoryQueue|
					MemoryStream|
					MmFile|
					MmFileStream|
					ModuleInfo|
					MulticastConduit|
					Mutex|
					NativeProtocol|
					NetCall|
					NetHost|
					NetworkAlert|
					NetworkCache|
					NetworkCall|
					NetworkClient|
					NetworkCombo|
					NetworkMessage|
					NetworkQueue|
					NetworkRegistry|
					NetworkTask|
					NotImplemented|
					Object|
					Observer|
					OutBuffer|
					OutputFilter|
					PersistQueue|
					Pipe|
					PipeConduit|
					Print|
					PrivateKey|
					Process|
					Properties|
					Protocol|
					ProtocolReader|
					ProtocolWriter|
					PublicKey|
					PullParser|
					QueueFile|
					QueueServer|
					QueueThread|
					QueuedCache|
					QuoteIterator|
					Random|
					Range|
					ReadWriteMutex|
					Reader|
					Record|
					RegExp|
					RegExpT|
					RegexIterator|
					RollCall|
					SSLCtx|
					SSLServerSocket|
					SSLSocketConduit|
					SaxParser|
					SelectionKey|
					Semaphore|
					ServerSocket|
					ServerThread|
					Service|
					SimpleIterator|
					SliceInputStream|
					SliceSeekInputStream|
					SliceSeekOutputStream|
					SliceStream|
					SnoopInput|
					SnoopOutput|
					Socket|
					SocketConduit|
					SocketListener|
					SocketSet|
					SocketStream|
					Sprint|
					Stream|
					StreamIterator|
					TArrayStream|
					TaskServer|
					TaskThread|
					TcpSocket|
					Telnet|
					TempFile|
					Text|
					TextFileInput|
					TextFileOutput|
					TextView|
					Thread|
					ThreadGroup|
					ThreadLocal|
					ThreadPool|
					Token|
					TypeInfo|
					TypeInfo_AC|
					TypeInfo_Aa|
					TypeInfo_Ab|
					TypeInfo_Ac|
					TypeInfo_Ad|
					TypeInfo_Ae|
					TypeInfo_Af|
					TypeInfo_Ag|
					TypeInfo_Ah|
					TypeInfo_Ai|
					TypeInfo_Aj|
					TypeInfo_Ak|
					TypeInfo_Al|
					TypeInfo_Am|
					TypeInfo_Ao|
					TypeInfo_Ap|
					TypeInfo_Aq|
					TypeInfo_Ar|
					TypeInfo_Array|
					TypeInfo_As|
					TypeInfo_AssociativeArray|
					TypeInfo_At|
					TypeInfo_Au|
					TypeInfo_Av|
					TypeInfo_Aw|
					TypeInfo_C|
					TypeInfo_Class|
					TypeInfo_D|
					TypeInfo_Delegate|
					TypeInfo_Enum|
					TypeInfo_Function|
					TypeInfo_Interface|
					TypeInfo_P|
					TypeInfo_Pointer|
					TypeInfo_StaticArray|
					TypeInfo_Struct|
					TypeInfo_Tuple|
					TypeInfo_Typedef|
					TypeInfo_a|
					TypeInfo_b|
					TypeInfo_c|
					TypeInfo_d|
					TypeInfo_e|
					TypeInfo_f|
					TypeInfo_g|
					TypeInfo_h|
					TypeInfo_i|
					TypeInfo_j|
					TypeInfo_k|
					TypeInfo_l|
					TypeInfo_m|
					TypeInfo_o|
					TypeInfo_p|
					TypeInfo_q|
					TypeInfo_r|
					TypeInfo_s|
					TypeInfo_t|
					TypeInfo_u|
					TypeInfo_v|
					TypeInfo_w|
					TypedInput|
					TypedOutput|
					URIerror|
					UdpSocket|
					UnCompress|
					UniText|
					UnicodeBom|
					UnicodeFile|
					UnknownAddress|
					Uri|
					UtfInput|
					UtfOutput|
					VirtualFolder|
					WrapSeekInputStream|
					WrapSeekOutputStream|
					Writer|
					XmlPrinter|
					ZipArchive|
					ZipBlockReader|
					ZipBlockWriter|
					ZipEntry|
					ZipEntryVerifier|
					ZipFile|
					ZipFileGroup|
					ZipFolder|
					ZipSubFolder|
					ZipSubFolderEntry|
					ZipSubFolderGroup|
					ZlibInput|
					ZlibOutput
				)\b'
  end

  rule 'support-type-built-ins-d' do
    pattern { include '#support-type-built-ins-exceptions-d' }
    pattern { include '#support-type-built-ins-classes-d' }
    pattern { include '#support-type-built-ins-interfaces-d' }
    pattern { include '#support-type-built-ins-structs-d' }
    pattern { include '#support-type-built-ins-aliases-d' }
    pattern { include '#support-type-built-ins-functions-d' }
    pattern { include '#support-type-built-ins-templates-d' }
  end

  rule 'support-type-built-ins-exceptions-d' do
    name 'support.type.built-ins.exceptions.d'
    match '(?x)
				\b(
					AddressException|
					ArrayBoundsError|
					ArrayBoundsException|
					AssertError|
					AssertException|
					Base64CharException|
					Base64Exception|
					BzipClosedException|
					BzipException|
					ClusterEmptyException|
					ClusterFullException|
					ConvError|
					ConvOverflowError|
					ConversionException|
					CorruptedIteratorException|
					DatabaseException|
					DateParseError|
					Exception|
					FTPException|
					FiberException|
					FileException|
					FinalizeException|
					FormatError|
					HostException|
					IOException|
					IllegalArgumentException|
					IllegalElementException|
					InvalidKeyException|
					InvalidTypeException|
					LocaleException|
					ModuleCtorError|
					NoSuchElementException|
					OpenException|
					OpenRJException|
					OutOfMemoryException|
					PlatformException|
					ProcessCreateException|
					ProcessException|
					ProcessForkException|
					ProcessKillException|
					ProcessWaitException|
					ReadException|
					RegExpException|
					RegexException|
					RegistryException|
					SeekException|
					SharedLibException|
					SocketAcceptException|
					SocketException|
					StdioException|
					StreamException|
					StreamFileException|
					StringException|
					SwitchError|
					SwitchException|
					SyncException|
					TextException|
					ThreadError|
					ThreadException|
					UnboxException|
					UnicodeException|
					UtfException|
					VariantTypeMismatchException|
					Win32Exception|
					WriteException|
					XmlException|
					ZipChecksumException|
					ZipException|
					ZipExhaustedException|
					ZipNotSupportedException|
					ZlibClosedException|
					ZlibException|
					OurUnwindException|
					SysError
				)\b'
  end

  rule 'support-type-built-ins-functions-d' do
    name 'support.type.built-ins.functions.d'
    match '(?x)
				\b(
					aaLiteral|
					assumeSafeAppend|
					byKey|
					byKeyValue|
					byValue|
					capacity|
					destroy|
					dup|
					get|
					keys|
					rehash|
					reserve|
					values
				)\b'
  end

  rule 'support-type-built-ins-interfaces-d' do
    name 'support.type.built-ins.interfaces.d'
    match '(?x)
				\b(
					Buffered|
					HttpParamsView|
					ICache|
					IChannel|
					IClassFactory|
					ICluster|
					IConduit|
					IConsumer|
					IEvent|
					IHierarchy|
					ILevel|
					IListener|
					IMessage|
					IMessageLoader|
					IOStream|
					IReadable|
					ISelectable|
					ISelectionSet|
					ISelector|
					IServer|
					IUnknown|
					IWritable|
					IXmlPrinter|
					InputStream|
					OutputStream|
					PathView|
					VfsFile|
					VfsFiles|
					VfsFolder|
					VfsFolderEntry|
					VfsFolders|
					VfsHost|
					VfsSync|
					ZipReader|
					ZipWriter
				)\b'
  end

  rule 'support-type-built-ins-structs-d' do
    name 'support.type.built-ins.structs.d'
    match '(?x)
				\b(
					ABC|
					ABCFLOAT|
					ACCEL|
					ACCESSTIMEOUT|
					ACCESS_ALLOWED_ACE|
					ACCESS_DENIED_ACE|
					ACE_HEADER|
					ACL|
					ACL_REVISION_INFORMATION|
					ACL_SIZE_INFORMATION|
					ACTION_HEADER|
					ADAPTER_STATUS|
					ADDJOB_INFO_1|
					ANIMATIONINFO|
					APPBARDATA|
					Argument|
					Atomic|
					Attribute|
					BITMAP|
					BITMAPCOREHEADER|
					BITMAPCOREINFO|
					BITMAPINFO|
					BITMAPINFOHEADER|
					BITMAPV4HEADER|
					BLOB|
					BROWSEINFO|
					BY_HANDLE_FILE_INFORMATION|
					Bar|
					Baz|
					BitArray|
					Box|
					BracketResult|
					ByteSwap|
					CANDIDATEFORM|
					CANDIDATELIST|
					CBTACTIVATESTRUCT|
					CBT_CREATEWND|
					CHARFORMAT|
					CHARRANGE|
					CHARSET|
					CHARSETINFO|
					CHAR_INFO|
					CIDA|
					CIEXYZ|
					CIEXYZTRIPLE|
					CLIENTCREATESTRUCT|
					CMINVOKECOMMANDINFO|
					COLORADJUSTMENT|
					COLORMAP|
					COMMCONFIG|
					COMMPROP|
					COMMTIMEOUTS|
					COMPAREITEMSTRUCT|
					COMPCOLOR|
					COMPOSITIONFORM|
					COMSTAT|
					CONNECTDLGSTRUCT|
					CONSOLE_CURSOR_INFO|
					CONTEXT|
					CONVCONTEXT|
					CONVINFO|
					COORD|
					COPYDATASTRUCT|
					CPINFO|
					CPLINFO|
					CREATESTRUCT|
					CREATE_PROCESS_DEBUG_INFO|
					CREATE_THREAD_DEBUG_INFO|
					CRITICAL_SECTION|
					CRITICAL_SECTION_DEBUG|
					CURRENCYFMT|
					CURSORSHAPE|
					CWPRETSTRUCT|
					CWPSTRUCT|
					CharClass|
					CharRange|
					Clock|
					CodePage|
					Console|
					DATATYPES_INFO_1|
					DCB|
					DDEACK|
					DDEADVISE|
					DDEDATA|
					DDELN|
					DDEML_MSG_HOOK_DATA|
					DDEPOKE|
					DDEUP|
					DEBUGHOOKINFO|
					DEBUG_EVENT|
					DELETEITEMSTRUCT|
					DEVMODE|
					DEVNAMES|
					DEV_BROADCAST_HDR|
					DEV_BROADCAST_OEM|
					DEV_BROADCAST_PORT|
					DEV_BROADCAST_VOLUME|
					DIBSECTION|
					DIR|
					DISCDLGSTRUCT|
					DISK_GEOMETRY|
					DISK_PERFORMANCE|
					DOCINFO|
					DOC_INFO_1|
					DOC_INFO_2|
					DRAGLISTINFO|
					DRAWITEMSTRUCT|
					DRAWTEXTPARAMS|
					DRIVER_INFO_1|
					DRIVER_INFO_2|
					DRIVER_INFO_3|
					DRIVE_LAYOUT_INFORMATION|
					Date|
					DateParse|
					DateTime|
					DirEntry|
					DynArg|
					EDITSTREAM|
					EMPTYRECORD|
					EMR|
					EMRABORTPATH|
					EMRANGLEARC|
					EMRARC|
					EMRBITBLT|
					EMRCREATEBRUSHINDIRECT|
					EMRCREATECOLORSPACE|
					EMRCREATEDIBPATTERNBRUSHPT|
					EMRCREATEMONOBRUSH|
					EMRCREATEPALETTE|
					EMRCREATEPEN|
					EMRELLIPSE|
					EMREOF|
					EMREXCLUDECLIPRECT|
					EMREXTCREATEFONTINDIRECTW|
					EMREXTCREATEPEN|
					EMREXTFLOODFILL|
					EMREXTSELECTCLIPRGN|
					EMREXTTEXTOUTA|
					EMRFILLPATH|
					EMRFILLRGN|
					EMRFORMAT|
					EMRFRAMERGN|
					EMRGDICOMMENT|
					EMRINVERTRGN|
					EMRLINETO|
					EMRMASKBLT|
					EMRMODIFYWORLDTRANSFORM|
					EMROFFSETCLIPRGN|
					EMRPLGBLT|
					EMRPOLYDRAW|
					EMRPOLYDRAW16|
					EMRPOLYLINE|
					EMRPOLYLINE16|
					EMRPOLYPOLYLINE|
					EMRPOLYPOLYLINE16|
					EMRPOLYTEXTOUTA|
					EMRRESIZEPALETTE|
					EMRRESTOREDC|
					EMRROUNDRECT|
					EMRSCALEVIEWPORTEXTEX|
					EMRSELECTCLIPPATH|
					EMRSELECTCOLORSPACE|
					EMRSELECTOBJECT|
					EMRSELECTPALETTE|
					EMRSETARCDIRECTION|
					EMRSETBKCOLOR|
					EMRSETCOLORADJUSTMENT|
					EMRSETDIBITSTODEVICE|
					EMRSETMAPPERFLAGS|
					EMRSETMITERLIMIT|
					EMRSETPALETTEENTRIES|
					EMRSETPIXELV|
					EMRSETVIEWPORTEXTEX|
					EMRSETVIEWPORTORGEX|
					EMRSETWORLDTRANSFORM|
					EMRSTRETCHBLT|
					EMRSTRETCHDIBITS|
					EMRTEXT|
					ENCORRECTTEXT|
					ENDROPFILES|
					ENHMETAHEADER|
					ENHMETARECORD|
					ENOLEOPFAILED|
					ENPROTECTED|
					ENSAVECLIPBOARD|
					ENUMLOGFONT|
					ENUMLOGFONTEX|
					ENUM_SERVICE_STATUS|
					EVENTLOGRECORD|
					EVENTMSG|
					EXCEPTION_DEBUG_INFO|
					EXCEPTION_POINTERS|
					EXCEPTION_RECORD|
					EXIT_PROCESS_DEBUG_INFO|
					EXIT_THREAD_DEBUG_INFO|
					EXTLOGFONT|
					EXTLOGPEN|
					EXT_BUTTON|
					EmptySlot|
					EndOfCDRecord|
					Environment|
					FILETIME|
					FILTERKEYS|
					FINDREPLACE|
					FINDTEXTEX|
					FIND_NAME_BUFFER|
					FIND_NAME_HEADER|
					FIXED|
					FLOATING_SAVE_AREA|
					FMS_GETDRIVEINFO|
					FMS_GETFILESEL|
					FMS_LOAD|
					FMS_TOOLBARLOAD|
					FOCUS_EVENT_RECORD|
					FONTSIGNATURE|
					FORMATRANGE|
					FORMAT_PARAMETERS|
					FORM_INFO_1|
					FileConst|
					FileHeader|
					FileRoots|
					FileSystem|
					FoldingCaseData|
					Foo|
					FtpConnectionDetail|
					FtpFeature|
					FtpFileInfo|
					FtpResponse|
					GC|
					GCP_RESULTS|
					GCStats|
					GENERIC_MAPPING|
					GLYPHMETRICS|
					GLYPHMETRICSFLOAT|
					GROUP_INFO_2|
					GUID|
					HANDLETABLE|
					HD_HITTESTINFO|
					HD_ITEM|
					HD_LAYOUT|
					HD_NOTIFY|
					HELPINFO|
					HELPWININFO|
					HIGHCONTRAST|
					HSZPAIR|
					HeaderElement|
					HttpConst|
					HttpHeader|
					HttpHeaderName|
					HttpResponses|
					HttpStatus|
					HttpToken|
					ICONINFO|
					ICONMETRICS|
					IMAGEINFO|
					IMAGE_DOS_HEADER|
					INPUT_RECORD|
					ITEMIDLIST|
					IeeeFlags|
					Interface|
					JOB_INFO_1|
					JOB_INFO_2|
					KERNINGPAIR|
					LANA_ENUM|
					LAYERPLANEDESCRIPTOR|
					LDT_ENTRY|
					LIST_ENTRY|
					LOAD_DLL_DEBUG_INFO|
					LOCALESIGNATURE|
					LOCALGROUP_INFO_0|
					LOCALGROUP_MEMBERS_INFO_0|
					LOCALGROUP_MEMBERS_INFO_3|
					LOGBRUSH|
					LOGCOLORSPACE|
					LOGFONT|
					LOGFONTA|
					LOGFONTW|
					LOGPALETTE|
					LOGPEN|
					LUID_AND_ATTRIBUTES|
					LV_COLUMN|
					LV_DISPINFO|
					LV_FINDINFO|
					LV_HITTESTINFO|
					LV_ITEM|
					LV_KEYDOWN|
					LocalFileHeader|
					MAT2|
					MD5_CTX|
					MDICREATESTRUCT|
					MEASUREITEMSTRUCT|
					MEMORYSTATUS|
					MEMORY_BASIC_INFORMATION|
					MENUEX_TEMPLATE_HEADER|
					MENUEX_TEMPLATE_ITEM|
					MENUITEMINFO|
					MENUITEMTEMPLATE|
					MENUITEMTEMPLATEHEADER|
					MENUTEMPLATE|
					MENU_EVENT_RECORD|
					METAFILEPICT|
					METARECORD|
					MINIMIZEDMETRICS|
					MINMAXINFO|
					MODEMDEVCAPS|
					MODEMSETTINGS|
					MONCBSTRUCT|
					MONCONVSTRUCT|
					MONERRSTRUCT|
					MONHSZSTRUCT|
					MONITOR_INFO_1|
					MONITOR_INFO_2|
					MONLINKSTRUCT|
					MONMSGSTRUCT|
					MOUSEHOOKSTRUCT|
					MOUSEKEYS|
					MOUSE_EVENT_RECORD|
					MSG|
					MSGBOXPARAMS|
					MSGFILTER|
					MULTIKEYHELP|
					NAME_BUFFER|
					NCB|
					NCCALCSIZE_PARAMS|
					NDDESHAREINFO|
					NETCONNECTINFOSTRUCT|
					NETINFOSTRUCT|
					NETRESOURCE|
					NEWCPLINFO|
					NEWTEXTMETRIC|
					NEWTEXTMETRICEX|
					NMHDR|
					NM_LISTVIEW|
					NM_TREEVIEW|
					NM_UPDOWNW|
					NONCLIENTMETRICS|
					NS_SERVICE_INFO|
					NUMBERFMT|
					OFNOTIFY|
					OFSTRUCT|
					OPENFILENAME|
					OPENFILENAMEA|
					OPENFILENAMEW|
					OSVERSIONINFO|
					OUTLINETEXTMETRIC|
					OUTPUT_DEBUG_STRING_INFO|
					OVERLAPPED|
					OffsetTypeInfo|
					PAINTSTRUCT|
					PALETTEENTRY|
					PANOSE|
					PARAFORMAT|
					PARTITION_INFORMATION|
					PERF_COUNTER_BLOCK|
					PERF_COUNTER_DEFINITION|
					PERF_DATA_BLOCK|
					PERF_INSTANCE_DEFINITION|
					PERF_OBJECT_TYPE|
					PIXELFORMATDESCRIPTOR|
					POINT|
					POINTFLOAT|
					POINTFX|
					POINTL|
					POINTS|
					POLYTEXT|
					PORT_INFO_1|
					PORT_INFO_2|
					PREVENT_MEDIA_REMOVAL|
					PRINTER_DEFAULTS|
					PRINTER_INFO_1|
					PRINTER_INFO_2|
					PRINTER_INFO_3|
					PRINTER_INFO_4|
					PRINTER_INFO_5|
					PRINTER_NOTIFY_INFO|
					PRINTER_NOTIFY_INFO_DATA|
					PRINTER_NOTIFY_OPTIONS|
					PRINTER_NOTIFY_OPTIONS_TYPE|
					PRINTPROCESSOR_INFO_1|
					PRIVILEGE_SET|
					PROCESS_HEAPENTRY|
					PROCESS_INFORMATION|
					PROPSHEETHEADER|
					PROPSHEETHEADER_U1|
					PROPSHEETHEADER_U2|
					PROPSHEETHEADER_U3|
					PROPSHEETPAGE|
					PROPSHEETPAGE_U1|
					PROPSHEETPAGE_U2|
					PROTOCOL_INFO|
					PROVIDOR_INFO_1|
					PSHNOTIFY|
					PUNCTUATION|
					PassByCopy|
					PassByRef|
					Phase1Info|
					PropertyConfigurator|
					QUERY_SERVICE_CONFIG|
					QUERY_SERVICE_LOCK_STATUS|
					RASAMB|
					RASCONN|
					RASCONNSTATUS|
					RASDIALEXTENSIONS|
					RASDIALPARAMS|
					RASENTRYNAME|
					RASPPPIP|
					RASPPPIPX|
					RASPPPNBF|
					RASTERIZER_STATUS|
					REASSIGN_BLOCKS|
					RECT|
					RECTL|
					REMOTE_NAME_INFO|
					REPASTESPECIAL|
					REQRESIZE|
					RGBQUAD|
					RGBTRIPLE|
					RGNDATA|
					RGNDATAHEADER|
					RIP_INFO|
					Runtime|
					SCROLLINFO|
					SECURITY_ATTRIBUTES|
					SECURITY_DESCRIPTOR|
					SECURITY_QUALITY_OF_SERVICE|
					SELCHANGE|
					SERIALKEYS|
					SERVICE_ADDRESS|
					SERVICE_ADDRESSES|
					SERVICE_INFO|
					SERVICE_STATUS|
					SERVICE_TABLE_ENTRY|
					SERVICE_TYPE_INFO_ABS|
					SERVICE_TYPE_VALUE_ABS|
					SESSION_BUFFER|
					SESSION_HEADER|
					SET_PARTITION_INFORMATION|
					SHFILEINFO|
					SHFILEOPSTRUCT|
					SHITEMID|
					SHNAMEMAPPING|
					SID|
					SID_AND_ATTRIBUTES|
					SID_IDENTIFIER_AUTHORITY|
					SINGLE_LIST_ENTRY|
					SIZE|
					SMALL_RECT|
					SOUNDSENTRY|
					STARTUPINFO|
					STICKYKEYS|
					STRRET|
					STYLEBUF|
					STYLESTRUCT|
					SYSTEMTIME|
					SYSTEM_AUDIT_ACE|
					SYSTEM_INFO|
					SYSTEM_INFO_U|
					SYSTEM_POWER_STATUS|
					Signal|
					SjLj_Function_Context|
					SpecialCaseData|
					TAPE_ERASE|
					TAPE_GET_DRIVE_PARAMETERS|
					TAPE_GET_MEDIA_PARAMETERS|
					TAPE_GET_POSITION|
					TAPE_PREPARE|
					TAPE_SET_DRIVE_PARAMETERS|
					TAPE_SET_MEDIA_PARAMETERS|
					TAPE_SET_POSITION|
					TAPE_WRITE_MARKS|
					TBADDBITMAP|
					TBBUTTON|
					TBNOTIFY|
					TBSAVEPARAMS|
					TCHOOSECOLOR|
					TCHOOSEFONT|
					TC_HITTESTINFO|
					TC_ITEM|
					TC_ITEMHEADER|
					TC_KEYDOWN|
					TEXTMETRIC|
					TEXTMETRICA|
					TEXTRANGE|
					TFINDTEXT|
					TIME_ZONE_INFORMATION|
					TOGGLEKEYS|
					TOKEN_CONTROL|
					TOKEN_DEFAULT_DACL|
					TOKEN_GROUPS|
					TOKEN_OWNER|
					TOKEN_PRIMARY_GROUP|
					TOKEN_PRIVILEGES|
					TOKEN_SOURCE|
					TOKEN_STATISTICS|
					TOKEN_USER|
					TOOLINFO|
					TOOLTIPTEXT|
					TPAGESETUPDLG|
					TPMPARAMS|
					TRANSMIT_FILE_BUFFERS|
					TREEITEM|
					TSMALLPOINT|
					TTHITTESTINFO|
					TTPOLYCURVE|
					TTPOLYGONHEADER|
					TVARIANT|
					TV_DISPINFO|
					TV_HITTESTINFO|
					TV_INSERTSTRUCT|
					TV_ITEM|
					TV_KEYDOWN|
					TV_SORTCB|
					Time|
					TimeOfDay|
					TimeSpan|
					Tuple|
					UDACCEL|
					ULARGE_INTEGER|
					UNIVERSAL_NAME_INFO|
					UNLOAD_DLL_DEBUG_INFO|
					USEROBJECTFLAGS|
					USER_INFO_0|
					USER_INFO_2|
					USER_INFO_3|
					UnicodeData|
					VALENT|
					VA_LIST|
					VERIFY_INFORMATION|
					VS_FIXEDFILEINFO|
					Variant|
					VfsFilterInfo|
					WIN32_FILE_ATTRIBUTE_DATA|
					WIN32_FIND_DATA|
					WIN32_FIND_DATAW|
					WIN32_STREAM_ID|
					WINDOWINFO|
					WINDOWPLACEMENT|
					WINDOWPOS|
					WINDOW_BUFFER_SIZE_RECORD|
					WNDCLASS|
					WNDCLASSA|
					WNDCLASSEX|
					WNDCLASSEXA|
					WSADATA|
					WallClock|
					XFORM|
					ZipEntryInfo
				)\b'
  end

  rule 'support-type-built-ins-templates-d' do
    name 'support.type.built-ins.templates.d'
    match '\b(AssociativeArray|RTInfo)\b'
  end

  rule 'support-type-d' do
    name 'support.type.d'
    match '\b((?:core|std)\.[\w\.]+)\b'
  end

  rule 'template-constraint-d' do
    pattern 'meta.definition.template-constraint.d' do
      match '\s*(if\s*\(\s*([^\)]+)\s*\)|)'

      capture 1 do
        pattern { include '$base' }
      end
    end
  end
end
