## --- File pointers

    fp = stdoutp()
    @test isa(fp, Ptr{StaticTools.FILE})
    @test stdoutp() == fp != 0
    fp = stderrp()
    @test isa(fp, Ptr{StaticTools.FILE})
    @test stderrp() == fp != 0
    fp = stdinp()
    @test isa(fp, Ptr{StaticTools.FILE})
    @test stdinp() == fp != 0

    name, mode = m"testfile.txt", m"w"
    fp = fopen(name, mode)
    @test isa(fp, Ptr{StaticTools.FILE})
    @test fp != 0
    @test fclose(fp) == 0
    @test free(name) == 0
    @test free(mode) == 0


## -- Test low-level printing functions on a variety of arguments

    @test puts("1") == 0
    @test printf("2") >= 0
    @test putchar('\n') == 0
    @test printf("%s\n", "3") >= 0
    @test printf(4) == 0
    @test printf(5.0) == 0
    @test printf(10.0f0) == 0
    @test printf(0x01) == 0
    @test printf(0x0001) == 0
    @test printf(0x00000001) == 0
    @test printf(0x0000000000000001) == 0
    @test printf(Ptr{UInt64}(0)) == 0

## -- low-level printing to file

    fp = fopen("testfile.txt", "w")
    @test isa(fp, Ptr{StaticTools.FILE})
    @test fp != 0

    @test puts(fp, "1") == 0
    @test printf(fp, "2") == 1
    @test putchar(fp, '\n') == 0
    @test printf(fp, "%s\n", "3") == 2
    @test printf(fp, 4) == 0
    @test printf(fp, 5.0) == 0
    @test printf(fp, 10.0f0) == 0
    @test printf(fp, 0x01) == 0
    @test printf(fp, 0x0001) == 0
    @test printf(fp, 0x00000001) == 0
    @test printf(fp, 0x0000000000000001) == 0
    @test printf(fp, Ptr{UInt64}(0)) == 0



## -- High-level printing

    # Print AbstractVector
    @test printf(1:5) == 0
    @test printf((1:5...,)) == 0
    @test printf(fp, 1:5) == 0
    @test printf(fp, (1:5...,)) == 0

    # Print AbstractArray
    @test printf((1:5)') == 0
    @test printf(rand(4,4)) == 0
    @test printf(fp, (1:5)') == 0
    @test printf(fp, rand(4,4)) == 0

    # Print MallocString
    str = m"Hello, world! 🌍"
    @test print(str) === nothing
    @test println(str) === nothing
    @test print(fp, str) === nothing
    @test println(fp, str) === nothing
    @test printf(str) == strlen(str)
    @test printf(fp, str) == strlen(str)
    @test puts(str) == 0
    @test printf(m"%s \n", str) >= 0
    show(str)

    # Print StaticString
    str = c"Hello, world! 🌍"
    @test print(str) === nothing
    @test println(str) === nothing
    @test print(fp, str) === nothing
    @test println(fp, str) === nothing
    @test printf(str) == strlen(str)
    @test printf(fp, str) == strlen(str)
    @test puts(str) == 0
    @test printf(m"%s \n", str) >= 0
    show(str)


## ---

    # Wrap up
    @test newline() == 0
    @test newline(fp) == 0
    @test StaticTools.system(c"echo Enough printing for now!") == 0
    @test fclose(fp) == 0
