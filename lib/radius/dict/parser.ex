# Default for opts on `parse_bin/2` manually removed to get rid of warning
# Generated from lib/radius/dict/parser.ex.exs, do not edit.
# Generated at 2023-06-12 12:12:16Z.

defmodule Radius.Dict.Parser do
  @moduledoc false
  def parse(binary) do
    {:ok, _, "", ctx, _, _} =
      parse_bin(binary, context: [attributes: [], values: [], prepend_key: []])

    ctx
  end

  def parse_index(binary) do
    includes =
      binary
      |> String.split("\n")
      |> Enum.filter(&String.starts_with?(&1, "$INCLUDE dictionary."))
      |> Enum.map(fn include ->
        String.replace_leading(include, "$INCLUDE dictionary.", "")
      end)

    parsed = parse(binary)

    {includes, Map.get(parsed, :attributes), Map.get(parsed, :values)}
  end

  @spec parse_bin(binary, keyword) ::
          {:ok, [term], rest, context, line, byte_offset}
          | {:error, reason, rest, context, line, byte_offset}
        when line: {pos_integer, byte_offset},
             byte_offset: pos_integer,
             rest: binary,
             reason: String.t(),
             context: map
  defp parse_bin(binary, opts) when is_binary(binary) do
    context = Map.new(Keyword.get(opts, :context, []))
    byte_offset = Keyword.get(opts, :byte_offset, 0)

    line =
      case Keyword.get(opts, :line, 1) do
        {_, _} = line -> line
        line -> {line, byte_offset}
      end

    case parse_bin__0(binary, [], [], context, line, byte_offset) do
      {:ok, acc, rest, context, line, offset} ->
        {:ok, :lists.reverse(acc), rest, context, line, offset}

      {:error, _, _, _, _, _} = error ->
        error
    end
  end

  defp parse_bin__0(rest, acc, stack, context, line, offset) do
    parse_bin__2(rest, [], [{rest, acc, context, line, offset} | stack], context, line, offset)
  end

  defp parse_bin__2(rest, acc, stack, context, line, offset) do
    parse_bin__441(rest, [], [{rest, context, line, offset}, acc | stack], context, line, offset)
  end

  defp parse_bin__4(rest, acc, stack, context, line, offset) do
    parse_bin__5(rest, [], [acc | stack], context, line, offset)
  end

  defp parse_bin__5(rest, acc, stack, context, line, offset) do
    parse_bin__9(rest, [], [{rest, context, line, offset}, acc | stack], context, line, offset)
  end

  defp parse_bin__7(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse_bin__6(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse_bin__8(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    parse_bin__7(rest, [], stack, context, line, offset)
  end

  defp parse_bin__9(rest, acc, stack, context, line, offset) do
    parse_bin__10(rest, [], [acc | stack], context, line, offset)
  end

  defp parse_bin__10(rest, acc, stack, context, line, offset) do
    parse_bin__11(rest, [], [acc | stack], context, line, offset)
  end

  defp parse_bin__11(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 === 32 or x0 === 9 do
    parse_bin__12(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__11(rest, _acc, stack, context, line, offset) do
    [_, acc | stack] = stack
    parse_bin__8(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__12(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 === 32 or x0 === 9 do
    parse_bin__14(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__12(rest, acc, stack, context, line, offset) do
    parse_bin__13(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__14(rest, acc, stack, context, line, offset) do
    parse_bin__12(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__13(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc
    parse_bin__15(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__15(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc
    parse_bin__16(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__16(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse_bin__6(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse_bin__6(<<"#", rest::binary>>, acc, stack, context, comb__line, comb__offset) do
    parse_bin__17(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__6(rest, _acc, stack, context, line, offset) do
    [_, _, acc | stack] = stack
    parse_bin__1(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__17(rest, acc, stack, context, line, offset) do
    parse_bin__21(rest, [], [{rest, context, line, offset}, acc | stack], context, line, offset)
  end

  defp parse_bin__19(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse_bin__18(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse_bin__20(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    parse_bin__19(rest, [], stack, context, line, offset)
  end

  defp parse_bin__21(rest, acc, stack, context, line, offset) do
    parse_bin__22(rest, [], [acc | stack], context, line, offset)
  end

  defp parse_bin__22(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 !== 10 do
    parse_bin__23(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__22(rest, _acc, stack, context, line, offset) do
    [acc | stack] = stack
    parse_bin__20(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__23(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 !== 10 do
    parse_bin__25(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__23(rest, acc, stack, context, line, offset) do
    parse_bin__24(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__25(rest, acc, stack, context, line, offset) do
    parse_bin__23(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__24(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc
    parse_bin__26(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__26(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse_bin__18(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse_bin__18(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc
    parse_bin__27(rest, [] ++ acc, stack, context, line, offset)
  end

  defp parse_bin__27(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse_bin__3(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse_bin__28(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    parse_bin__4(rest, [], stack, context, line, offset)
  end

  defp parse_bin__29(rest, acc, stack, context, line, offset) do
    parse_bin__30(rest, [], [acc | stack], context, line, offset)
  end

  defp parse_bin__30(<<"$INCLUDE", rest::binary>>, acc, stack, context, comb__line, comb__offset) do
    parse_bin__31(rest, acc, stack, context, comb__line, comb__offset + 8)
  end

  defp parse_bin__30(rest, _acc, stack, context, line, offset) do
    [acc | stack] = stack
    parse_bin__28(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__31(rest, acc, stack, context, line, offset) do
    parse_bin__32(rest, [], [acc | stack], context, line, offset)
  end

  defp parse_bin__32(rest, acc, stack, context, line, offset) do
    parse_bin__33(rest, [], [acc | stack], context, line, offset)
  end

  defp parse_bin__33(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 === 32 or x0 === 9 do
    parse_bin__34(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__33(rest, _acc, stack, context, line, offset) do
    [_, _, acc | stack] = stack
    parse_bin__28(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__34(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 === 32 or x0 === 9 do
    parse_bin__36(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__34(rest, acc, stack, context, line, offset) do
    parse_bin__35(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__36(rest, acc, stack, context, line, offset) do
    parse_bin__34(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__35(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc
    parse_bin__37(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__37(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc
    parse_bin__38(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__38(
         <<"dictionary.", rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       ) do
    parse_bin__39(rest, acc, stack, context, comb__line, comb__offset + 11)
  end

  defp parse_bin__38(rest, _acc, stack, context, line, offset) do
    [acc | stack] = stack
    parse_bin__28(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__39(rest, acc, stack, context, line, offset) do
    parse_bin__40(rest, [], [acc | stack], context, line, offset)
  end

  defp parse_bin__40(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 !== 9 and x0 !== 10 and x0 !== 32 do
    parse_bin__41(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__40(rest, _acc, stack, context, line, offset) do
    [_, acc | stack] = stack
    parse_bin__28(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__41(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 !== 9 and x0 !== 10 and x0 !== 32 do
    parse_bin__43(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__41(rest, acc, stack, context, line, offset) do
    parse_bin__42(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__43(rest, acc, stack, context, line, offset) do
    parse_bin__41(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__42(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc
    parse_bin__44(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__44(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc
    parse_bin__45(rest, [] ++ acc, stack, context, line, offset)
  end

  defp parse_bin__45(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse_bin__3(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse_bin__46(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    parse_bin__29(rest, [], stack, context, line, offset)
  end

  defp parse_bin__47(rest, acc, stack, context, line, offset) do
    parse_bin__48(rest, [], [acc | stack], context, line, offset)
  end

  defp parse_bin__48(rest, acc, stack, context, line, offset) do
    parse_bin__49(rest, [], [acc | stack], context, line, offset)
  end

  defp parse_bin__49(rest, acc, stack, context, line, offset) do
    parse_bin__50(rest, [], [acc | stack], context, line, offset)
  end

  defp parse_bin__50(
         <<"BEGIN-VENDOR", rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       ) do
    parse_bin__51(rest, acc, stack, context, comb__line, comb__offset + 12)
  end

  defp parse_bin__50(rest, _acc, stack, context, line, offset) do
    [_, _, acc | stack] = stack
    parse_bin__46(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__51(rest, acc, stack, context, line, offset) do
    parse_bin__52(rest, [], [acc | stack], context, line, offset)
  end

  defp parse_bin__52(rest, acc, stack, context, line, offset) do
    parse_bin__53(rest, [], [acc | stack], context, line, offset)
  end

  defp parse_bin__53(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 === 32 or x0 === 9 do
    parse_bin__54(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__53(rest, _acc, stack, context, line, offset) do
    [_, _, _, _, acc | stack] = stack
    parse_bin__46(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__54(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 === 32 or x0 === 9 do
    parse_bin__56(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__54(rest, acc, stack, context, line, offset) do
    parse_bin__55(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__56(rest, acc, stack, context, line, offset) do
    parse_bin__54(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__55(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc
    parse_bin__57(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__57(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc
    parse_bin__58(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__58(rest, acc, stack, context, line, offset) do
    parse_bin__59(rest, [], [acc | stack], context, line, offset)
  end

  defp parse_bin__59(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 !== 9 and x0 !== 10 and x0 !== 32 do
    parse_bin__60(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__59(rest, _acc, stack, context, line, offset) do
    [_, _, _, acc | stack] = stack
    parse_bin__46(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__60(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 !== 9 and x0 !== 10 and x0 !== 32 do
    parse_bin__62(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__60(rest, acc, stack, context, line, offset) do
    parse_bin__61(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__62(rest, acc, stack, context, line, offset) do
    parse_bin__60(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__61(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc
    parse_bin__63(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__63(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc
    parse_bin__64(rest, [] ++ acc, stack, context, line, offset)
  end

  defp parse_bin__64(rest, user_acc, [acc | stack], context, line, offset) do
    case (case prepend_store_key(rest, user_acc, context, line, offset, [:vendor]) do
            {_, _, _} = res -> res
            {:error, reason} -> {:error, reason}
            {acc, context} -> {rest, acc, context}
          end) do
      {rest, user_acc, context} when is_list(user_acc) ->
        parse_bin__65(rest, user_acc ++ acc, stack, context, line, offset)

      {:error, reason} ->
        {:error, reason, rest, context, line, offset}
    end
  end

  defp parse_bin__65(rest, acc, stack, context, line, offset) do
    parse_bin__67(rest, [], [{rest, acc, context, line, offset} | stack], context, line, offset)
  end

  defp parse_bin__67(rest, acc, stack, context, line, offset) do
    parse_bin__226(rest, [], [{rest, context, line, offset}, acc | stack], context, line, offset)
  end

  defp parse_bin__69(rest, acc, stack, context, line, offset) do
    parse_bin__70(rest, [], [acc | stack], context, line, offset)
  end

  defp parse_bin__70(rest, acc, stack, context, line, offset) do
    parse_bin__74(rest, [], [{rest, context, line, offset}, acc | stack], context, line, offset)
  end

  defp parse_bin__72(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse_bin__71(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse_bin__73(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    parse_bin__72(rest, [], stack, context, line, offset)
  end

  defp parse_bin__74(rest, acc, stack, context, line, offset) do
    parse_bin__75(rest, [], [acc | stack], context, line, offset)
  end

  defp parse_bin__75(rest, acc, stack, context, line, offset) do
    parse_bin__76(rest, [], [acc | stack], context, line, offset)
  end

  defp parse_bin__76(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 === 32 or x0 === 9 do
    parse_bin__77(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__76(rest, _acc, stack, context, line, offset) do
    [_, acc | stack] = stack
    parse_bin__73(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__77(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 === 32 or x0 === 9 do
    parse_bin__79(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__77(rest, acc, stack, context, line, offset) do
    parse_bin__78(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__79(rest, acc, stack, context, line, offset) do
    parse_bin__77(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__78(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc
    parse_bin__80(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__80(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc
    parse_bin__81(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__81(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse_bin__71(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse_bin__71(<<"#", rest::binary>>, acc, stack, context, comb__line, comb__offset) do
    parse_bin__82(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__71(rest, _acc, stack, context, line, offset) do
    [_, _, acc | stack] = stack
    parse_bin__66(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__82(rest, acc, stack, context, line, offset) do
    parse_bin__86(rest, [], [{rest, context, line, offset}, acc | stack], context, line, offset)
  end

  defp parse_bin__84(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse_bin__83(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse_bin__85(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    parse_bin__84(rest, [], stack, context, line, offset)
  end

  defp parse_bin__86(rest, acc, stack, context, line, offset) do
    parse_bin__87(rest, [], [acc | stack], context, line, offset)
  end

  defp parse_bin__87(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 !== 10 do
    parse_bin__88(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__87(rest, _acc, stack, context, line, offset) do
    [acc | stack] = stack
    parse_bin__85(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__88(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 !== 10 do
    parse_bin__90(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__88(rest, acc, stack, context, line, offset) do
    parse_bin__89(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__90(rest, acc, stack, context, line, offset) do
    parse_bin__88(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__89(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc
    parse_bin__91(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__91(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse_bin__83(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse_bin__83(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc
    parse_bin__92(rest, [] ++ acc, stack, context, line, offset)
  end

  defp parse_bin__92(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse_bin__68(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse_bin__93(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    parse_bin__69(rest, [], stack, context, line, offset)
  end

  defp parse_bin__94(rest, acc, stack, context, line, offset) do
    parse_bin__95(rest, [], [acc | stack], context, line, offset)
  end

  defp parse_bin__95(<<"VALUE", rest::binary>>, acc, stack, context, comb__line, comb__offset) do
    parse_bin__96(rest, [:value] ++ acc, stack, context, comb__line, comb__offset + 5)
  end

  defp parse_bin__95(rest, _acc, stack, context, line, offset) do
    [acc | stack] = stack
    parse_bin__93(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__96(rest, acc, stack, context, line, offset) do
    parse_bin__97(rest, [], [acc | stack], context, line, offset)
  end

  defp parse_bin__97(rest, acc, stack, context, line, offset) do
    parse_bin__98(rest, [], [acc | stack], context, line, offset)
  end

  defp parse_bin__98(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 === 32 or x0 === 9 do
    parse_bin__99(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__98(rest, _acc, stack, context, line, offset) do
    [_, _, acc | stack] = stack
    parse_bin__93(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__99(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 === 32 or x0 === 9 do
    parse_bin__101(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__99(rest, acc, stack, context, line, offset) do
    parse_bin__100(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__101(rest, acc, stack, context, line, offset) do
    parse_bin__99(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__100(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc
    parse_bin__102(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__102(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc
    parse_bin__103(rest, [] ++ acc, stack, context, line, offset)
  end

  defp parse_bin__103(rest, acc, stack, context, line, offset) do
    parse_bin__104(rest, [], [acc | stack], context, line, offset)
  end

  defp parse_bin__104(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 !== 9 and x0 !== 10 and x0 !== 32 do
    parse_bin__105(rest, [<<x0::integer>>] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__104(rest, _acc, stack, context, line, offset) do
    [_, acc | stack] = stack
    parse_bin__93(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__105(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 !== 9 and x0 !== 10 and x0 !== 32 do
    parse_bin__107(rest, [x0] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__105(rest, acc, stack, context, line, offset) do
    parse_bin__106(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__107(rest, acc, stack, context, line, offset) do
    parse_bin__105(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__106(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc

    parse_bin__108(
      rest,
      [List.to_string(:lists.reverse(user_acc))] ++ acc,
      stack,
      context,
      line,
      offset
    )
  end

  defp parse_bin__108(rest, acc, stack, context, line, offset) do
    parse_bin__109(rest, [], [acc | stack], context, line, offset)
  end

  defp parse_bin__109(rest, acc, stack, context, line, offset) do
    parse_bin__110(rest, [], [acc | stack], context, line, offset)
  end

  defp parse_bin__110(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 === 32 or x0 === 9 do
    parse_bin__111(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__110(rest, _acc, stack, context, line, offset) do
    [_, _, acc | stack] = stack
    parse_bin__93(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__111(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 === 32 or x0 === 9 do
    parse_bin__113(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__111(rest, acc, stack, context, line, offset) do
    parse_bin__112(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__113(rest, acc, stack, context, line, offset) do
    parse_bin__111(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__112(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc
    parse_bin__114(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__114(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc
    parse_bin__115(rest, [] ++ acc, stack, context, line, offset)
  end

  defp parse_bin__115(rest, acc, stack, context, line, offset) do
    parse_bin__116(rest, [], [acc | stack], context, line, offset)
  end

  defp parse_bin__116(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 !== 9 and x0 !== 10 and x0 !== 32 do
    parse_bin__117(rest, [<<x0::integer>>] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__116(rest, _acc, stack, context, line, offset) do
    [_, acc | stack] = stack
    parse_bin__93(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__117(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 !== 9 and x0 !== 10 and x0 !== 32 do
    parse_bin__119(rest, [x0] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__117(rest, acc, stack, context, line, offset) do
    parse_bin__118(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__119(rest, acc, stack, context, line, offset) do
    parse_bin__117(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__118(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc

    parse_bin__120(
      rest,
      [List.to_string(:lists.reverse(user_acc))] ++ acc,
      stack,
      context,
      line,
      offset
    )
  end

  defp parse_bin__120(rest, acc, stack, context, line, offset) do
    parse_bin__121(rest, [], [acc | stack], context, line, offset)
  end

  defp parse_bin__121(rest, acc, stack, context, line, offset) do
    parse_bin__122(rest, [], [acc | stack], context, line, offset)
  end

  defp parse_bin__122(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 === 32 or x0 === 9 do
    parse_bin__123(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__122(rest, _acc, stack, context, line, offset) do
    [_, _, acc | stack] = stack
    parse_bin__93(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__123(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 === 32 or x0 === 9 do
    parse_bin__125(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__123(rest, acc, stack, context, line, offset) do
    parse_bin__124(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__125(rest, acc, stack, context, line, offset) do
    parse_bin__123(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__124(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc
    parse_bin__126(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__126(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc
    parse_bin__127(rest, [] ++ acc, stack, context, line, offset)
  end

  defp parse_bin__127(rest, acc, stack, context, line, offset) do
    parse_bin__147(rest, [], [{rest, context, line, offset}, acc | stack], context, line, offset)
  end

  defp parse_bin__129(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 >= 48 and x0 <= 57 do
    parse_bin__130(rest, [x0 - 48] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__129(rest, _acc, stack, context, line, offset) do
    [_, _, acc | stack] = stack
    parse_bin__93(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__130(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse_bin__128(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse_bin__131(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    parse_bin__129(rest, [], stack, context, line, offset)
  end

  defp parse_bin__132(<<x0, x1, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 >= 48 and x0 <= 57 and (x1 >= 48 and x1 <= 57) do
    parse_bin__133(
      rest,
      [x1 - 48 + (x0 - 48) * 10] ++ acc,
      stack,
      context,
      comb__line,
      comb__offset + 2
    )
  end

  defp parse_bin__132(rest, acc, stack, context, line, offset) do
    parse_bin__131(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__133(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse_bin__128(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse_bin__134(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    parse_bin__132(rest, [], stack, context, line, offset)
  end

  defp parse_bin__135(<<x0, x1, x2, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 >= 48 and x0 <= 57 and (x1 >= 48 and x1 <= 57) and (x2 >= 48 and x2 <= 57) do
    parse_bin__136(
      rest,
      [x2 - 48 + (x1 - 48) * 10 + (x0 - 48) * 100] ++ acc,
      stack,
      context,
      comb__line,
      comb__offset + 3
    )
  end

  defp parse_bin__135(rest, acc, stack, context, line, offset) do
    parse_bin__134(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__136(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse_bin__128(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse_bin__137(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    parse_bin__135(rest, [], stack, context, line, offset)
  end

  defp parse_bin__138(
         <<x0, x1, x2, x3, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 >= 48 and x0 <= 57 and (x1 >= 48 and x1 <= 57) and (x2 >= 48 and x2 <= 57) and
              (x3 >= 48 and x3 <= 57) do
    parse_bin__139(
      rest,
      [x3 - 48 + (x2 - 48) * 10 + (x1 - 48) * 100 + (x0 - 48) * 1000] ++ acc,
      stack,
      context,
      comb__line,
      comb__offset + 4
    )
  end

  defp parse_bin__138(rest, acc, stack, context, line, offset) do
    parse_bin__137(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__139(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse_bin__128(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse_bin__140(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    parse_bin__138(rest, [], stack, context, line, offset)
  end

  defp parse_bin__141(
         <<x0, x1, x2, x3, x4, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 >= 48 and x0 <= 57 and (x1 >= 48 and x1 <= 57) and (x2 >= 48 and x2 <= 57) and
              (x3 >= 48 and x3 <= 57) and (x4 >= 48 and x4 <= 57) do
    parse_bin__142(
      rest,
      [x4 - 48 + (x3 - 48) * 10 + (x2 - 48) * 100 + (x1 - 48) * 1000 + (x0 - 48) * 10000] ++ acc,
      stack,
      context,
      comb__line,
      comb__offset + 5
    )
  end

  defp parse_bin__141(rest, acc, stack, context, line, offset) do
    parse_bin__140(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__142(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse_bin__128(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse_bin__143(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    parse_bin__141(rest, [], stack, context, line, offset)
  end

  defp parse_bin__144(
         <<x0, x1, x2, x3, x4, x5, x6, x7, x8, x9, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 >= 48 and x0 <= 57 and (x1 >= 48 and x1 <= 57) and (x2 >= 48 and x2 <= 57) and
              (x3 >= 48 and x3 <= 57) and (x4 >= 48 and x4 <= 57) and (x5 >= 48 and x5 <= 57) and
              (x6 >= 48 and x6 <= 57) and (x7 >= 48 and x7 <= 57) and (x8 >= 48 and x8 <= 57) and
              (x9 >= 48 and x9 <= 57) do
    parse_bin__145(
      rest,
      [
        x9 - 48 + (x8 - 48) * 10 + (x7 - 48) * 100 + (x6 - 48) * 1000 + (x5 - 48) * 10000 +
          (x4 - 48) * 100_000 + (x3 - 48) * 1_000_000 + (x2 - 48) * 10_000_000 +
          (x1 - 48) * 100_000_000 + (x0 - 48) * 1_000_000_000
      ] ++ acc,
      stack,
      context,
      comb__line,
      comb__offset + 10
    )
  end

  defp parse_bin__144(rest, acc, stack, context, line, offset) do
    parse_bin__143(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__145(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse_bin__128(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse_bin__146(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    parse_bin__144(rest, [], stack, context, line, offset)
  end

  defp parse_bin__147(rest, acc, stack, context, line, offset) do
    parse_bin__148(rest, [], [acc | stack], context, line, offset)
  end

  defp parse_bin__148(<<"0x", rest::binary>>, acc, stack, context, comb__line, comb__offset) do
    parse_bin__149(rest, [] ++ acc, stack, context, comb__line, comb__offset + 2)
  end

  defp parse_bin__148(rest, _acc, stack, context, line, offset) do
    [acc | stack] = stack
    parse_bin__146(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__149(
         <<x0, x1, x2, x3, x4, x5, x6, x7, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when ((x0 >= 97 and x0 <= 102) or (x0 >= 65 and x0 <= 70) or (x0 >= 48 and x0 <= 57)) and
              ((x1 >= 97 and x1 <= 102) or (x1 >= 65 and x1 <= 70) or (x1 >= 48 and x1 <= 57)) and
              ((x2 >= 97 and x2 <= 102) or (x2 >= 65 and x2 <= 70) or (x2 >= 48 and x2 <= 57)) and
              ((x3 >= 97 and x3 <= 102) or (x3 >= 65 and x3 <= 70) or (x3 >= 48 and x3 <= 57)) and
              ((x4 >= 97 and x4 <= 102) or (x4 >= 65 and x4 <= 70) or (x4 >= 48 and x4 <= 57)) and
              ((x5 >= 97 and x5 <= 102) or (x5 >= 65 and x5 <= 70) or (x5 >= 48 and x5 <= 57)) and
              ((x6 >= 97 and x6 <= 102) or (x6 >= 65 and x6 <= 70) or (x6 >= 48 and x6 <= 57)) and
              ((x7 >= 97 and x7 <= 102) or (x7 >= 65 and x7 <= 70) or (x7 >= 48 and x7 <= 57)) do
    parse_bin__150(
      rest,
      [
        <<x0::integer, x1::integer, x2::integer, x3::integer, x4::integer, x5::integer,
          x6::integer, x7::integer>>
      ] ++ acc,
      stack,
      context,
      comb__line,
      comb__offset + 8
    )
  end

  defp parse_bin__149(
         <<x0, x1, x2, x3, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when ((x0 >= 97 and x0 <= 102) or (x0 >= 65 and x0 <= 70) or (x0 >= 48 and x0 <= 57)) and
              ((x1 >= 97 and x1 <= 102) or (x1 >= 65 and x1 <= 70) or (x1 >= 48 and x1 <= 57)) and
              ((x2 >= 97 and x2 <= 102) or (x2 >= 65 and x2 <= 70) or (x2 >= 48 and x2 <= 57)) and
              ((x3 >= 97 and x3 <= 102) or (x3 >= 65 and x3 <= 70) or (x3 >= 48 and x3 <= 57)) do
    parse_bin__150(
      rest,
      [<<x0::integer, x1::integer, x2::integer, x3::integer>>] ++ acc,
      stack,
      context,
      comb__line,
      comb__offset + 4
    )
  end

  defp parse_bin__149(<<x0, x1, x2, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when ((x0 >= 97 and x0 <= 102) or (x0 >= 65 and x0 <= 70) or (x0 >= 48 and x0 <= 57)) and
              ((x1 >= 97 and x1 <= 102) or (x1 >= 65 and x1 <= 70) or (x1 >= 48 and x1 <= 57)) and
              ((x2 >= 97 and x2 <= 102) or (x2 >= 65 and x2 <= 70) or (x2 >= 48 and x2 <= 57)) do
    parse_bin__150(
      rest,
      [<<x0::integer, x1::integer, x2::integer>>] ++ acc,
      stack,
      context,
      comb__line,
      comb__offset + 3
    )
  end

  defp parse_bin__149(<<x0, x1, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when ((x0 >= 97 and x0 <= 102) or (x0 >= 65 and x0 <= 70) or (x0 >= 48 and x0 <= 57)) and
              ((x1 >= 97 and x1 <= 102) or (x1 >= 65 and x1 <= 70) or (x1 >= 48 and x1 <= 57)) do
    parse_bin__150(
      rest,
      [<<x0::integer, x1::integer>>] ++ acc,
      stack,
      context,
      comb__line,
      comb__offset + 2
    )
  end

  defp parse_bin__149(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when (x0 >= 97 and x0 <= 102) or (x0 >= 65 and x0 <= 70) or (x0 >= 48 and x0 <= 57) do
    parse_bin__150(rest, [<<x0::integer>>] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__149(rest, _acc, stack, context, line, offset) do
    [acc | stack] = stack
    parse_bin__146(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__150(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc

    parse_bin__151(
      rest,
      [hex_to_integer(:lists.reverse(user_acc))] ++ acc,
      stack,
      context,
      line,
      offset
    )
  end

  defp parse_bin__151(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse_bin__128(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse_bin__128(rest, user_acc, [acc | stack], context, line, offset) do
    case (case store_value(rest, user_acc, context, line, offset) do
            {_, _, _} = res -> res
            {:error, reason} -> {:error, reason}
            {acc, context} -> {rest, acc, context}
          end) do
      {rest, user_acc, context} when is_list(user_acc) ->
        parse_bin__152(rest, user_acc ++ acc, stack, context, line, offset)

      {:error, reason} ->
        {:error, reason, rest, context, line, offset}
    end
  end

  defp parse_bin__152(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse_bin__68(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse_bin__153(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    parse_bin__94(rest, [], stack, context, line, offset)
  end

  defp parse_bin__154(rest, acc, stack, context, line, offset) do
    parse_bin__155(rest, [], [acc | stack], context, line, offset)
  end

  defp parse_bin__155(
         <<"ATTRIBUTE", rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       ) do
    parse_bin__156(rest, [:attribute] ++ acc, stack, context, comb__line, comb__offset + 9)
  end

  defp parse_bin__155(rest, _acc, stack, context, line, offset) do
    [acc | stack] = stack
    parse_bin__153(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__156(rest, acc, stack, context, line, offset) do
    parse_bin__157(rest, [], [acc | stack], context, line, offset)
  end

  defp parse_bin__157(rest, acc, stack, context, line, offset) do
    parse_bin__158(rest, [], [acc | stack], context, line, offset)
  end

  defp parse_bin__158(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 === 32 or x0 === 9 do
    parse_bin__159(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__158(rest, _acc, stack, context, line, offset) do
    [_, _, acc | stack] = stack
    parse_bin__153(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__159(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 === 32 or x0 === 9 do
    parse_bin__161(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__159(rest, acc, stack, context, line, offset) do
    parse_bin__160(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__161(rest, acc, stack, context, line, offset) do
    parse_bin__159(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__160(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc
    parse_bin__162(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__162(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc
    parse_bin__163(rest, [] ++ acc, stack, context, line, offset)
  end

  defp parse_bin__163(rest, acc, stack, context, line, offset) do
    parse_bin__164(rest, [], [acc | stack], context, line, offset)
  end

  defp parse_bin__164(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 !== 9 and x0 !== 10 and x0 !== 32 do
    parse_bin__165(rest, [<<x0::integer>>] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__164(rest, _acc, stack, context, line, offset) do
    [_, acc | stack] = stack
    parse_bin__153(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__165(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 !== 9 and x0 !== 10 and x0 !== 32 do
    parse_bin__167(rest, [x0] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__165(rest, acc, stack, context, line, offset) do
    parse_bin__166(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__167(rest, acc, stack, context, line, offset) do
    parse_bin__165(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__166(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc

    parse_bin__168(
      rest,
      [List.to_string(:lists.reverse(user_acc))] ++ acc,
      stack,
      context,
      line,
      offset
    )
  end

  defp parse_bin__168(rest, acc, stack, context, line, offset) do
    parse_bin__169(rest, [], [acc | stack], context, line, offset)
  end

  defp parse_bin__169(rest, acc, stack, context, line, offset) do
    parse_bin__170(rest, [], [acc | stack], context, line, offset)
  end

  defp parse_bin__170(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 === 32 or x0 === 9 do
    parse_bin__171(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__170(rest, _acc, stack, context, line, offset) do
    [_, _, acc | stack] = stack
    parse_bin__153(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__171(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 === 32 or x0 === 9 do
    parse_bin__173(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__171(rest, acc, stack, context, line, offset) do
    parse_bin__172(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__173(rest, acc, stack, context, line, offset) do
    parse_bin__171(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__172(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc
    parse_bin__174(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__174(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc
    parse_bin__175(rest, [] ++ acc, stack, context, line, offset)
  end

  defp parse_bin__175(rest, acc, stack, context, line, offset) do
    parse_bin__195(rest, [], [{rest, context, line, offset}, acc | stack], context, line, offset)
  end

  defp parse_bin__177(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 >= 48 and x0 <= 57 do
    parse_bin__178(rest, [x0 - 48] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__177(rest, _acc, stack, context, line, offset) do
    [_, _, acc | stack] = stack
    parse_bin__153(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__178(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse_bin__176(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse_bin__179(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    parse_bin__177(rest, [], stack, context, line, offset)
  end

  defp parse_bin__180(<<x0, x1, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 >= 48 and x0 <= 57 and (x1 >= 48 and x1 <= 57) do
    parse_bin__181(
      rest,
      [x1 - 48 + (x0 - 48) * 10] ++ acc,
      stack,
      context,
      comb__line,
      comb__offset + 2
    )
  end

  defp parse_bin__180(rest, acc, stack, context, line, offset) do
    parse_bin__179(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__181(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse_bin__176(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse_bin__182(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    parse_bin__180(rest, [], stack, context, line, offset)
  end

  defp parse_bin__183(<<x0, x1, x2, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 >= 48 and x0 <= 57 and (x1 >= 48 and x1 <= 57) and (x2 >= 48 and x2 <= 57) do
    parse_bin__184(
      rest,
      [x2 - 48 + (x1 - 48) * 10 + (x0 - 48) * 100] ++ acc,
      stack,
      context,
      comb__line,
      comb__offset + 3
    )
  end

  defp parse_bin__183(rest, acc, stack, context, line, offset) do
    parse_bin__182(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__184(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse_bin__176(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse_bin__185(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    parse_bin__183(rest, [], stack, context, line, offset)
  end

  defp parse_bin__186(
         <<x0, x1, x2, x3, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 >= 48 and x0 <= 57 and (x1 >= 48 and x1 <= 57) and (x2 >= 48 and x2 <= 57) and
              (x3 >= 48 and x3 <= 57) do
    parse_bin__187(
      rest,
      [x3 - 48 + (x2 - 48) * 10 + (x1 - 48) * 100 + (x0 - 48) * 1000] ++ acc,
      stack,
      context,
      comb__line,
      comb__offset + 4
    )
  end

  defp parse_bin__186(rest, acc, stack, context, line, offset) do
    parse_bin__185(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__187(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse_bin__176(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse_bin__188(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    parse_bin__186(rest, [], stack, context, line, offset)
  end

  defp parse_bin__189(
         <<x0, x1, x2, x3, x4, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 >= 48 and x0 <= 57 and (x1 >= 48 and x1 <= 57) and (x2 >= 48 and x2 <= 57) and
              (x3 >= 48 and x3 <= 57) and (x4 >= 48 and x4 <= 57) do
    parse_bin__190(
      rest,
      [x4 - 48 + (x3 - 48) * 10 + (x2 - 48) * 100 + (x1 - 48) * 1000 + (x0 - 48) * 10000] ++ acc,
      stack,
      context,
      comb__line,
      comb__offset + 5
    )
  end

  defp parse_bin__189(rest, acc, stack, context, line, offset) do
    parse_bin__188(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__190(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse_bin__176(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse_bin__191(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    parse_bin__189(rest, [], stack, context, line, offset)
  end

  defp parse_bin__192(
         <<x0, x1, x2, x3, x4, x5, x6, x7, x8, x9, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 >= 48 and x0 <= 57 and (x1 >= 48 and x1 <= 57) and (x2 >= 48 and x2 <= 57) and
              (x3 >= 48 and x3 <= 57) and (x4 >= 48 and x4 <= 57) and (x5 >= 48 and x5 <= 57) and
              (x6 >= 48 and x6 <= 57) and (x7 >= 48 and x7 <= 57) and (x8 >= 48 and x8 <= 57) and
              (x9 >= 48 and x9 <= 57) do
    parse_bin__193(
      rest,
      [
        x9 - 48 + (x8 - 48) * 10 + (x7 - 48) * 100 + (x6 - 48) * 1000 + (x5 - 48) * 10000 +
          (x4 - 48) * 100_000 + (x3 - 48) * 1_000_000 + (x2 - 48) * 10_000_000 +
          (x1 - 48) * 100_000_000 + (x0 - 48) * 1_000_000_000
      ] ++ acc,
      stack,
      context,
      comb__line,
      comb__offset + 10
    )
  end

  defp parse_bin__192(rest, acc, stack, context, line, offset) do
    parse_bin__191(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__193(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse_bin__176(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse_bin__194(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    parse_bin__192(rest, [], stack, context, line, offset)
  end

  defp parse_bin__195(rest, acc, stack, context, line, offset) do
    parse_bin__196(rest, [], [acc | stack], context, line, offset)
  end

  defp parse_bin__196(<<"0x", rest::binary>>, acc, stack, context, comb__line, comb__offset) do
    parse_bin__197(rest, [] ++ acc, stack, context, comb__line, comb__offset + 2)
  end

  defp parse_bin__196(rest, _acc, stack, context, line, offset) do
    [acc | stack] = stack
    parse_bin__194(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__197(
         <<x0, x1, x2, x3, x4, x5, x6, x7, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when ((x0 >= 97 and x0 <= 102) or (x0 >= 65 and x0 <= 70) or (x0 >= 48 and x0 <= 57)) and
              ((x1 >= 97 and x1 <= 102) or (x1 >= 65 and x1 <= 70) or (x1 >= 48 and x1 <= 57)) and
              ((x2 >= 97 and x2 <= 102) or (x2 >= 65 and x2 <= 70) or (x2 >= 48 and x2 <= 57)) and
              ((x3 >= 97 and x3 <= 102) or (x3 >= 65 and x3 <= 70) or (x3 >= 48 and x3 <= 57)) and
              ((x4 >= 97 and x4 <= 102) or (x4 >= 65 and x4 <= 70) or (x4 >= 48 and x4 <= 57)) and
              ((x5 >= 97 and x5 <= 102) or (x5 >= 65 and x5 <= 70) or (x5 >= 48 and x5 <= 57)) and
              ((x6 >= 97 and x6 <= 102) or (x6 >= 65 and x6 <= 70) or (x6 >= 48 and x6 <= 57)) and
              ((x7 >= 97 and x7 <= 102) or (x7 >= 65 and x7 <= 70) or (x7 >= 48 and x7 <= 57)) do
    parse_bin__198(
      rest,
      [
        <<x0::integer, x1::integer, x2::integer, x3::integer, x4::integer, x5::integer,
          x6::integer, x7::integer>>
      ] ++ acc,
      stack,
      context,
      comb__line,
      comb__offset + 8
    )
  end

  defp parse_bin__197(
         <<x0, x1, x2, x3, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when ((x0 >= 97 and x0 <= 102) or (x0 >= 65 and x0 <= 70) or (x0 >= 48 and x0 <= 57)) and
              ((x1 >= 97 and x1 <= 102) or (x1 >= 65 and x1 <= 70) or (x1 >= 48 and x1 <= 57)) and
              ((x2 >= 97 and x2 <= 102) or (x2 >= 65 and x2 <= 70) or (x2 >= 48 and x2 <= 57)) and
              ((x3 >= 97 and x3 <= 102) or (x3 >= 65 and x3 <= 70) or (x3 >= 48 and x3 <= 57)) do
    parse_bin__198(
      rest,
      [<<x0::integer, x1::integer, x2::integer, x3::integer>>] ++ acc,
      stack,
      context,
      comb__line,
      comb__offset + 4
    )
  end

  defp parse_bin__197(<<x0, x1, x2, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when ((x0 >= 97 and x0 <= 102) or (x0 >= 65 and x0 <= 70) or (x0 >= 48 and x0 <= 57)) and
              ((x1 >= 97 and x1 <= 102) or (x1 >= 65 and x1 <= 70) or (x1 >= 48 and x1 <= 57)) and
              ((x2 >= 97 and x2 <= 102) or (x2 >= 65 and x2 <= 70) or (x2 >= 48 and x2 <= 57)) do
    parse_bin__198(
      rest,
      [<<x0::integer, x1::integer, x2::integer>>] ++ acc,
      stack,
      context,
      comb__line,
      comb__offset + 3
    )
  end

  defp parse_bin__197(<<x0, x1, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when ((x0 >= 97 and x0 <= 102) or (x0 >= 65 and x0 <= 70) or (x0 >= 48 and x0 <= 57)) and
              ((x1 >= 97 and x1 <= 102) or (x1 >= 65 and x1 <= 70) or (x1 >= 48 and x1 <= 57)) do
    parse_bin__198(
      rest,
      [<<x0::integer, x1::integer>>] ++ acc,
      stack,
      context,
      comb__line,
      comb__offset + 2
    )
  end

  defp parse_bin__197(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when (x0 >= 97 and x0 <= 102) or (x0 >= 65 and x0 <= 70) or (x0 >= 48 and x0 <= 57) do
    parse_bin__198(rest, [<<x0::integer>>] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__197(rest, _acc, stack, context, line, offset) do
    [acc | stack] = stack
    parse_bin__194(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__198(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc

    parse_bin__199(
      rest,
      [hex_to_integer(:lists.reverse(user_acc))] ++ acc,
      stack,
      context,
      line,
      offset
    )
  end

  defp parse_bin__199(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse_bin__176(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse_bin__176(rest, acc, stack, context, line, offset) do
    parse_bin__200(rest, [], [acc | stack], context, line, offset)
  end

  defp parse_bin__200(rest, acc, stack, context, line, offset) do
    parse_bin__201(rest, [], [acc | stack], context, line, offset)
  end

  defp parse_bin__201(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 === 32 or x0 === 9 do
    parse_bin__202(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__201(rest, _acc, stack, context, line, offset) do
    [_, _, acc | stack] = stack
    parse_bin__153(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__202(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 === 32 or x0 === 9 do
    parse_bin__204(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__202(rest, acc, stack, context, line, offset) do
    parse_bin__203(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__204(rest, acc, stack, context, line, offset) do
    parse_bin__202(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__203(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc
    parse_bin__205(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__205(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc
    parse_bin__206(rest, [] ++ acc, stack, context, line, offset)
  end

  defp parse_bin__206(<<"string", rest::binary>>, acc, stack, context, comb__line, comb__offset) do
    parse_bin__207(rest, [:string] ++ acc, stack, context, comb__line, comb__offset + 6)
  end

  defp parse_bin__206(<<"octets", rest::binary>>, acc, stack, context, comb__line, comb__offset) do
    parse_bin__207(rest, [:octets] ++ acc, stack, context, comb__line, comb__offset + 6)
  end

  defp parse_bin__206(<<"ipaddr", rest::binary>>, acc, stack, context, comb__line, comb__offset) do
    parse_bin__207(rest, [:ipaddr] ++ acc, stack, context, comb__line, comb__offset + 6)
  end

  defp parse_bin__206(<<"integer", rest::binary>>, acc, stack, context, comb__line, comb__offset) do
    parse_bin__207(rest, [:integer] ++ acc, stack, context, comb__line, comb__offset + 7)
  end

  defp parse_bin__206(<<"signed", rest::binary>>, acc, stack, context, comb__line, comb__offset) do
    parse_bin__207(rest, [:signed] ++ acc, stack, context, comb__line, comb__offset + 6)
  end

  defp parse_bin__206(<<"date", rest::binary>>, acc, stack, context, comb__line, comb__offset) do
    parse_bin__207(rest, [:date] ++ acc, stack, context, comb__line, comb__offset + 4)
  end

  defp parse_bin__206(<<"ifid", rest::binary>>, acc, stack, context, comb__line, comb__offset) do
    parse_bin__207(rest, [:ifid] ++ acc, stack, context, comb__line, comb__offset + 4)
  end

  defp parse_bin__206(<<"ipv6addr", rest::binary>>, acc, stack, context, comb__line, comb__offset) do
    parse_bin__207(rest, [:ipv6addr] ++ acc, stack, context, comb__line, comb__offset + 8)
  end

  defp parse_bin__206(
         <<"ipv6prefix", rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       ) do
    parse_bin__207(rest, [:ipv6prefix] ++ acc, stack, context, comb__line, comb__offset + 10)
  end

  defp parse_bin__206(<<"ether", rest::binary>>, acc, stack, context, comb__line, comb__offset) do
    parse_bin__207(rest, [:ether] ++ acc, stack, context, comb__line, comb__offset + 5)
  end

  defp parse_bin__206(<<"abinary", rest::binary>>, acc, stack, context, comb__line, comb__offset) do
    parse_bin__207(rest, [:abinary] ++ acc, stack, context, comb__line, comb__offset + 7)
  end

  defp parse_bin__206(<<"byte", rest::binary>>, acc, stack, context, comb__line, comb__offset) do
    parse_bin__207(rest, [:byte] ++ acc, stack, context, comb__line, comb__offset + 4)
  end

  defp parse_bin__206(<<"short", rest::binary>>, acc, stack, context, comb__line, comb__offset) do
    parse_bin__207(rest, [:short] ++ acc, stack, context, comb__line, comb__offset + 5)
  end

  defp parse_bin__206(rest, _acc, stack, context, line, offset) do
    [acc | stack] = stack
    parse_bin__153(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__207(rest, acc, stack, context, line, offset) do
    parse_bin__211(rest, [], [{rest, context, line, offset}, acc | stack], context, line, offset)
  end

  defp parse_bin__209(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse_bin__208(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse_bin__210(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    parse_bin__209(rest, [], stack, context, line, offset)
  end

  defp parse_bin__211(rest, acc, stack, context, line, offset) do
    parse_bin__212(rest, [], [acc | stack], context, line, offset)
  end

  defp parse_bin__212(rest, acc, stack, context, line, offset) do
    parse_bin__213(rest, [], [acc | stack], context, line, offset)
  end

  defp parse_bin__213(rest, acc, stack, context, line, offset) do
    parse_bin__214(rest, [], [acc | stack], context, line, offset)
  end

  defp parse_bin__214(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 === 32 or x0 === 9 do
    parse_bin__215(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__214(rest, _acc, stack, context, line, offset) do
    [_, _, acc | stack] = stack
    parse_bin__210(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__215(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 === 32 or x0 === 9 do
    parse_bin__217(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__215(rest, acc, stack, context, line, offset) do
    parse_bin__216(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__217(rest, acc, stack, context, line, offset) do
    parse_bin__215(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__216(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc
    parse_bin__218(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__218(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc
    parse_bin__219(rest, [] ++ acc, stack, context, line, offset)
  end

  defp parse_bin__219(<<"has_tag", rest::binary>>, acc, stack, context, comb__line, comb__offset) do
    parse_bin__220(rest, [has_tag: true] ++ acc, stack, context, comb__line, comb__offset + 7)
  end

  defp parse_bin__219(<<rest::binary>>, acc, stack, context, comb__line, comb__offset) do
    parse_bin__220(rest, [] ++ acc, stack, context, comb__line, comb__offset)
  end

  defp parse_bin__220(<<",", rest::binary>>, acc, stack, context, comb__line, comb__offset) do
    parse_bin__221(rest, [] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__220(<<rest::binary>>, acc, stack, context, comb__line, comb__offset) do
    parse_bin__221(rest, [] ++ acc, stack, context, comb__line, comb__offset)
  end

  defp parse_bin__221(
         <<"encrypt=", x0, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 >= 48 and x0 <= 57 do
    parse_bin__222(rest, [encrypt: x0 - 48] ++ acc, stack, context, comb__line, comb__offset + 9)
  end

  defp parse_bin__221(<<rest::binary>>, acc, stack, context, comb__line, comb__offset) do
    parse_bin__222(rest, [] ++ acc, stack, context, comb__line, comb__offset)
  end

  defp parse_bin__222(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc
    parse_bin__223(rest, [opts: :lists.reverse(user_acc)] ++ acc, stack, context, line, offset)
  end

  defp parse_bin__223(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse_bin__208(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse_bin__208(rest, user_acc, [acc | stack], context, line, offset) do
    case (case store_attribute(rest, user_acc, context, line, offset) do
            {_, _, _} = res -> res
            {:error, reason} -> {:error, reason}
            {acc, context} -> {rest, acc, context}
          end) do
      {rest, user_acc, context} when is_list(user_acc) ->
        parse_bin__224(rest, user_acc ++ acc, stack, context, line, offset)

      {:error, reason} ->
        {:error, reason, rest, context, line, offset}
    end
  end

  defp parse_bin__224(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse_bin__68(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse_bin__225(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    parse_bin__154(rest, [], stack, context, line, offset)
  end

  defp parse_bin__226(<<"\n", rest::binary>>, acc, stack, context, comb__line, comb__offset) do
    parse_bin__227(
      rest,
      [] ++ acc,
      stack,
      context,
      {elem(comb__line, 0) + 1, comb__offset + 1},
      comb__offset + 1
    )
  end

  defp parse_bin__226(rest, acc, stack, context, line, offset) do
    parse_bin__225(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__227(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse_bin__68(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse_bin__66(_, _, [{rest, acc, context, line, offset} | stack], _, _, _) do
    parse_bin__228(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__68(
         inner_rest,
         inner_acc,
         [{rest, acc, context, line, offset} | stack],
         inner_context,
         inner_line,
         inner_offset
       ) do
    _ = {rest, acc, context, line, offset}

    parse_bin__67(
      inner_rest,
      [],
      [{inner_rest, inner_acc ++ acc, inner_context, inner_line, inner_offset} | stack],
      inner_context,
      inner_line,
      inner_offset
    )
  end

  defp parse_bin__228(rest, acc, stack, context, line, offset) do
    parse_bin__229(rest, [], [acc | stack], context, line, offset)
  end

  defp parse_bin__229(
         <<"END-VENDOR", rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       ) do
    parse_bin__230(rest, acc, stack, context, comb__line, comb__offset + 10)
  end

  defp parse_bin__229(rest, _acc, stack, context, line, offset) do
    [_, acc | stack] = stack
    parse_bin__46(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__230(rest, acc, stack, context, line, offset) do
    parse_bin__231(rest, [], [acc | stack], context, line, offset)
  end

  defp parse_bin__231(rest, acc, stack, context, line, offset) do
    parse_bin__232(rest, [], [acc | stack], context, line, offset)
  end

  defp parse_bin__232(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 === 32 or x0 === 9 do
    parse_bin__233(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__232(rest, _acc, stack, context, line, offset) do
    [_, _, _, acc | stack] = stack
    parse_bin__46(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__233(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 === 32 or x0 === 9 do
    parse_bin__235(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__233(rest, acc, stack, context, line, offset) do
    parse_bin__234(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__235(rest, acc, stack, context, line, offset) do
    parse_bin__233(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__234(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc
    parse_bin__236(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__236(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc
    parse_bin__237(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__237(rest, acc, stack, context, line, offset) do
    parse_bin__238(rest, [], [acc | stack], context, line, offset)
  end

  defp parse_bin__238(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 !== 9 and x0 !== 10 and x0 !== 32 do
    parse_bin__239(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__238(rest, _acc, stack, context, line, offset) do
    [_, _, acc | stack] = stack
    parse_bin__46(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__239(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 !== 9 and x0 !== 10 and x0 !== 32 do
    parse_bin__241(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__239(rest, acc, stack, context, line, offset) do
    parse_bin__240(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__241(rest, acc, stack, context, line, offset) do
    parse_bin__239(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__240(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc
    parse_bin__242(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__242(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc
    parse_bin__243(rest, [] ++ acc, stack, context, line, offset)
  end

  defp parse_bin__243(rest, user_acc, [acc | stack], context, line, offset) do
    case (case prepend_store_key(rest, user_acc, context, line, offset, []) do
            {_, _, _} = res -> res
            {:error, reason} -> {:error, reason}
            {acc, context} -> {rest, acc, context}
          end) do
      {rest, user_acc, context} when is_list(user_acc) ->
        parse_bin__244(rest, user_acc ++ acc, stack, context, line, offset)

      {:error, reason} ->
        {:error, reason, rest, context, line, offset}
    end
  end

  defp parse_bin__244(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse_bin__3(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse_bin__245(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    parse_bin__47(rest, [], stack, context, line, offset)
  end

  defp parse_bin__246(rest, acc, stack, context, line, offset) do
    parse_bin__247(rest, [], [acc | stack], context, line, offset)
  end

  defp parse_bin__247(<<"VENDOR", rest::binary>>, acc, stack, context, comb__line, comb__offset) do
    parse_bin__248(rest, [:vendor] ++ acc, stack, context, comb__line, comb__offset + 6)
  end

  defp parse_bin__247(rest, _acc, stack, context, line, offset) do
    [acc | stack] = stack
    parse_bin__245(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__248(rest, acc, stack, context, line, offset) do
    parse_bin__249(rest, [], [acc | stack], context, line, offset)
  end

  defp parse_bin__249(rest, acc, stack, context, line, offset) do
    parse_bin__250(rest, [], [acc | stack], context, line, offset)
  end

  defp parse_bin__250(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 === 32 or x0 === 9 do
    parse_bin__251(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__250(rest, _acc, stack, context, line, offset) do
    [_, _, acc | stack] = stack
    parse_bin__245(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__251(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 === 32 or x0 === 9 do
    parse_bin__253(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__251(rest, acc, stack, context, line, offset) do
    parse_bin__252(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__253(rest, acc, stack, context, line, offset) do
    parse_bin__251(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__252(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc
    parse_bin__254(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__254(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc
    parse_bin__255(rest, [] ++ acc, stack, context, line, offset)
  end

  defp parse_bin__255(rest, acc, stack, context, line, offset) do
    parse_bin__256(rest, [], [acc | stack], context, line, offset)
  end

  defp parse_bin__256(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 !== 9 and x0 !== 10 and x0 !== 32 do
    parse_bin__257(rest, [<<x0::integer>>] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__256(rest, _acc, stack, context, line, offset) do
    [_, acc | stack] = stack
    parse_bin__245(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__257(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 !== 9 and x0 !== 10 and x0 !== 32 do
    parse_bin__259(rest, [x0] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__257(rest, acc, stack, context, line, offset) do
    parse_bin__258(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__259(rest, acc, stack, context, line, offset) do
    parse_bin__257(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__258(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc

    parse_bin__260(
      rest,
      [List.to_string(:lists.reverse(user_acc))] ++ acc,
      stack,
      context,
      line,
      offset
    )
  end

  defp parse_bin__260(rest, acc, stack, context, line, offset) do
    parse_bin__261(rest, [], [acc | stack], context, line, offset)
  end

  defp parse_bin__261(rest, acc, stack, context, line, offset) do
    parse_bin__262(rest, [], [acc | stack], context, line, offset)
  end

  defp parse_bin__262(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 === 32 or x0 === 9 do
    parse_bin__263(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__262(rest, _acc, stack, context, line, offset) do
    [_, _, acc | stack] = stack
    parse_bin__245(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__263(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 === 32 or x0 === 9 do
    parse_bin__265(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__263(rest, acc, stack, context, line, offset) do
    parse_bin__264(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__265(rest, acc, stack, context, line, offset) do
    parse_bin__263(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__264(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc
    parse_bin__266(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__266(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc
    parse_bin__267(rest, [] ++ acc, stack, context, line, offset)
  end

  defp parse_bin__267(rest, acc, stack, context, line, offset) do
    parse_bin__287(rest, [], [{rest, context, line, offset}, acc | stack], context, line, offset)
  end

  defp parse_bin__269(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 >= 48 and x0 <= 57 do
    parse_bin__270(rest, [x0 - 48] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__269(rest, _acc, stack, context, line, offset) do
    [_, _, acc | stack] = stack
    parse_bin__245(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__270(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse_bin__268(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse_bin__271(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    parse_bin__269(rest, [], stack, context, line, offset)
  end

  defp parse_bin__272(<<x0, x1, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 >= 48 and x0 <= 57 and (x1 >= 48 and x1 <= 57) do
    parse_bin__273(
      rest,
      [x1 - 48 + (x0 - 48) * 10] ++ acc,
      stack,
      context,
      comb__line,
      comb__offset + 2
    )
  end

  defp parse_bin__272(rest, acc, stack, context, line, offset) do
    parse_bin__271(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__273(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse_bin__268(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse_bin__274(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    parse_bin__272(rest, [], stack, context, line, offset)
  end

  defp parse_bin__275(<<x0, x1, x2, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 >= 48 and x0 <= 57 and (x1 >= 48 and x1 <= 57) and (x2 >= 48 and x2 <= 57) do
    parse_bin__276(
      rest,
      [x2 - 48 + (x1 - 48) * 10 + (x0 - 48) * 100] ++ acc,
      stack,
      context,
      comb__line,
      comb__offset + 3
    )
  end

  defp parse_bin__275(rest, acc, stack, context, line, offset) do
    parse_bin__274(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__276(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse_bin__268(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse_bin__277(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    parse_bin__275(rest, [], stack, context, line, offset)
  end

  defp parse_bin__278(
         <<x0, x1, x2, x3, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 >= 48 and x0 <= 57 and (x1 >= 48 and x1 <= 57) and (x2 >= 48 and x2 <= 57) and
              (x3 >= 48 and x3 <= 57) do
    parse_bin__279(
      rest,
      [x3 - 48 + (x2 - 48) * 10 + (x1 - 48) * 100 + (x0 - 48) * 1000] ++ acc,
      stack,
      context,
      comb__line,
      comb__offset + 4
    )
  end

  defp parse_bin__278(rest, acc, stack, context, line, offset) do
    parse_bin__277(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__279(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse_bin__268(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse_bin__280(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    parse_bin__278(rest, [], stack, context, line, offset)
  end

  defp parse_bin__281(
         <<x0, x1, x2, x3, x4, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 >= 48 and x0 <= 57 and (x1 >= 48 and x1 <= 57) and (x2 >= 48 and x2 <= 57) and
              (x3 >= 48 and x3 <= 57) and (x4 >= 48 and x4 <= 57) do
    parse_bin__282(
      rest,
      [x4 - 48 + (x3 - 48) * 10 + (x2 - 48) * 100 + (x1 - 48) * 1000 + (x0 - 48) * 10000] ++ acc,
      stack,
      context,
      comb__line,
      comb__offset + 5
    )
  end

  defp parse_bin__281(rest, acc, stack, context, line, offset) do
    parse_bin__280(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__282(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse_bin__268(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse_bin__283(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    parse_bin__281(rest, [], stack, context, line, offset)
  end

  defp parse_bin__284(
         <<x0, x1, x2, x3, x4, x5, x6, x7, x8, x9, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 >= 48 and x0 <= 57 and (x1 >= 48 and x1 <= 57) and (x2 >= 48 and x2 <= 57) and
              (x3 >= 48 and x3 <= 57) and (x4 >= 48 and x4 <= 57) and (x5 >= 48 and x5 <= 57) and
              (x6 >= 48 and x6 <= 57) and (x7 >= 48 and x7 <= 57) and (x8 >= 48 and x8 <= 57) and
              (x9 >= 48 and x9 <= 57) do
    parse_bin__285(
      rest,
      [
        x9 - 48 + (x8 - 48) * 10 + (x7 - 48) * 100 + (x6 - 48) * 1000 + (x5 - 48) * 10000 +
          (x4 - 48) * 100_000 + (x3 - 48) * 1_000_000 + (x2 - 48) * 10_000_000 +
          (x1 - 48) * 100_000_000 + (x0 - 48) * 1_000_000_000
      ] ++ acc,
      stack,
      context,
      comb__line,
      comb__offset + 10
    )
  end

  defp parse_bin__284(rest, acc, stack, context, line, offset) do
    parse_bin__283(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__285(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse_bin__268(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse_bin__286(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    parse_bin__284(rest, [], stack, context, line, offset)
  end

  defp parse_bin__287(rest, acc, stack, context, line, offset) do
    parse_bin__288(rest, [], [acc | stack], context, line, offset)
  end

  defp parse_bin__288(<<"0x", rest::binary>>, acc, stack, context, comb__line, comb__offset) do
    parse_bin__289(rest, [] ++ acc, stack, context, comb__line, comb__offset + 2)
  end

  defp parse_bin__288(rest, _acc, stack, context, line, offset) do
    [acc | stack] = stack
    parse_bin__286(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__289(
         <<x0, x1, x2, x3, x4, x5, x6, x7, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when ((x0 >= 97 and x0 <= 102) or (x0 >= 65 and x0 <= 70) or (x0 >= 48 and x0 <= 57)) and
              ((x1 >= 97 and x1 <= 102) or (x1 >= 65 and x1 <= 70) or (x1 >= 48 and x1 <= 57)) and
              ((x2 >= 97 and x2 <= 102) or (x2 >= 65 and x2 <= 70) or (x2 >= 48 and x2 <= 57)) and
              ((x3 >= 97 and x3 <= 102) or (x3 >= 65 and x3 <= 70) or (x3 >= 48 and x3 <= 57)) and
              ((x4 >= 97 and x4 <= 102) or (x4 >= 65 and x4 <= 70) or (x4 >= 48 and x4 <= 57)) and
              ((x5 >= 97 and x5 <= 102) or (x5 >= 65 and x5 <= 70) or (x5 >= 48 and x5 <= 57)) and
              ((x6 >= 97 and x6 <= 102) or (x6 >= 65 and x6 <= 70) or (x6 >= 48 and x6 <= 57)) and
              ((x7 >= 97 and x7 <= 102) or (x7 >= 65 and x7 <= 70) or (x7 >= 48 and x7 <= 57)) do
    parse_bin__290(
      rest,
      [
        <<x0::integer, x1::integer, x2::integer, x3::integer, x4::integer, x5::integer,
          x6::integer, x7::integer>>
      ] ++ acc,
      stack,
      context,
      comb__line,
      comb__offset + 8
    )
  end

  defp parse_bin__289(
         <<x0, x1, x2, x3, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when ((x0 >= 97 and x0 <= 102) or (x0 >= 65 and x0 <= 70) or (x0 >= 48 and x0 <= 57)) and
              ((x1 >= 97 and x1 <= 102) or (x1 >= 65 and x1 <= 70) or (x1 >= 48 and x1 <= 57)) and
              ((x2 >= 97 and x2 <= 102) or (x2 >= 65 and x2 <= 70) or (x2 >= 48 and x2 <= 57)) and
              ((x3 >= 97 and x3 <= 102) or (x3 >= 65 and x3 <= 70) or (x3 >= 48 and x3 <= 57)) do
    parse_bin__290(
      rest,
      [<<x0::integer, x1::integer, x2::integer, x3::integer>>] ++ acc,
      stack,
      context,
      comb__line,
      comb__offset + 4
    )
  end

  defp parse_bin__289(<<x0, x1, x2, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when ((x0 >= 97 and x0 <= 102) or (x0 >= 65 and x0 <= 70) or (x0 >= 48 and x0 <= 57)) and
              ((x1 >= 97 and x1 <= 102) or (x1 >= 65 and x1 <= 70) or (x1 >= 48 and x1 <= 57)) and
              ((x2 >= 97 and x2 <= 102) or (x2 >= 65 and x2 <= 70) or (x2 >= 48 and x2 <= 57)) do
    parse_bin__290(
      rest,
      [<<x0::integer, x1::integer, x2::integer>>] ++ acc,
      stack,
      context,
      comb__line,
      comb__offset + 3
    )
  end

  defp parse_bin__289(<<x0, x1, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when ((x0 >= 97 and x0 <= 102) or (x0 >= 65 and x0 <= 70) or (x0 >= 48 and x0 <= 57)) and
              ((x1 >= 97 and x1 <= 102) or (x1 >= 65 and x1 <= 70) or (x1 >= 48 and x1 <= 57)) do
    parse_bin__290(
      rest,
      [<<x0::integer, x1::integer>>] ++ acc,
      stack,
      context,
      comb__line,
      comb__offset + 2
    )
  end

  defp parse_bin__289(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when (x0 >= 97 and x0 <= 102) or (x0 >= 65 and x0 <= 70) or (x0 >= 48 and x0 <= 57) do
    parse_bin__290(rest, [<<x0::integer>>] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__289(rest, _acc, stack, context, line, offset) do
    [acc | stack] = stack
    parse_bin__286(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__290(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc

    parse_bin__291(
      rest,
      [hex_to_integer(:lists.reverse(user_acc))] ++ acc,
      stack,
      context,
      line,
      offset
    )
  end

  defp parse_bin__291(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse_bin__268(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse_bin__268(rest, acc, stack, context, line, offset) do
    parse_bin__295(rest, [], [{rest, context, line, offset}, acc | stack], context, line, offset)
  end

  defp parse_bin__293(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse_bin__292(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse_bin__294(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    parse_bin__293(rest, [], stack, context, line, offset)
  end

  defp parse_bin__295(rest, acc, stack, context, line, offset) do
    parse_bin__296(rest, [], [acc | stack], context, line, offset)
  end

  defp parse_bin__296(rest, acc, stack, context, line, offset) do
    parse_bin__297(rest, [], [acc | stack], context, line, offset)
  end

  defp parse_bin__297(rest, acc, stack, context, line, offset) do
    parse_bin__298(rest, [], [acc | stack], context, line, offset)
  end

  defp parse_bin__298(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 === 32 or x0 === 9 do
    parse_bin__299(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__298(rest, _acc, stack, context, line, offset) do
    [_, _, acc | stack] = stack
    parse_bin__294(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__299(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 === 32 or x0 === 9 do
    parse_bin__301(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__299(rest, acc, stack, context, line, offset) do
    parse_bin__300(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__301(rest, acc, stack, context, line, offset) do
    parse_bin__299(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__300(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc
    parse_bin__302(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__302(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc
    parse_bin__303(rest, [] ++ acc, stack, context, line, offset)
  end

  defp parse_bin__303(
         <<"format=", x0, ",", x1, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 >= 48 and x0 <= 57 and (x1 >= 48 and x1 <= 57) do
    parse_bin__304(rest, [x1 - 48, x0 - 48] ++ acc, stack, context, comb__line, comb__offset + 10)
  end

  defp parse_bin__303(rest, _acc, stack, context, line, offset) do
    [acc | stack] = stack
    parse_bin__294(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__304(<<",c", rest::binary>>, acc, stack, context, comb__line, comb__offset) do
    parse_bin__305(rest, [] ++ acc, stack, context, comb__line, comb__offset + 2)
  end

  defp parse_bin__304(<<rest::binary>>, acc, stack, context, comb__line, comb__offset) do
    parse_bin__305(rest, [] ++ acc, stack, context, comb__line, comb__offset)
  end

  defp parse_bin__305(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc
    parse_bin__306(rest, [format: :lists.reverse(user_acc)] ++ acc, stack, context, line, offset)
  end

  defp parse_bin__306(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse_bin__292(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse_bin__292(rest, user_acc, [acc | stack], context, line, offset) do
    case (case store_vendor(rest, user_acc, context, line, offset) do
            {_, _, _} = res -> res
            {:error, reason} -> {:error, reason}
            {acc, context} -> {rest, acc, context}
          end) do
      {rest, user_acc, context} when is_list(user_acc) ->
        parse_bin__307(rest, user_acc ++ acc, stack, context, line, offset)

      {:error, reason} ->
        {:error, reason, rest, context, line, offset}
    end
  end

  defp parse_bin__307(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse_bin__3(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse_bin__308(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    parse_bin__246(rest, [], stack, context, line, offset)
  end

  defp parse_bin__309(rest, acc, stack, context, line, offset) do
    parse_bin__310(rest, [], [acc | stack], context, line, offset)
  end

  defp parse_bin__310(<<"VALUE", rest::binary>>, acc, stack, context, comb__line, comb__offset) do
    parse_bin__311(rest, [:value] ++ acc, stack, context, comb__line, comb__offset + 5)
  end

  defp parse_bin__310(rest, _acc, stack, context, line, offset) do
    [acc | stack] = stack
    parse_bin__308(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__311(rest, acc, stack, context, line, offset) do
    parse_bin__312(rest, [], [acc | stack], context, line, offset)
  end

  defp parse_bin__312(rest, acc, stack, context, line, offset) do
    parse_bin__313(rest, [], [acc | stack], context, line, offset)
  end

  defp parse_bin__313(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 === 32 or x0 === 9 do
    parse_bin__314(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__313(rest, _acc, stack, context, line, offset) do
    [_, _, acc | stack] = stack
    parse_bin__308(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__314(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 === 32 or x0 === 9 do
    parse_bin__316(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__314(rest, acc, stack, context, line, offset) do
    parse_bin__315(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__316(rest, acc, stack, context, line, offset) do
    parse_bin__314(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__315(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc
    parse_bin__317(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__317(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc
    parse_bin__318(rest, [] ++ acc, stack, context, line, offset)
  end

  defp parse_bin__318(rest, acc, stack, context, line, offset) do
    parse_bin__319(rest, [], [acc | stack], context, line, offset)
  end

  defp parse_bin__319(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 !== 9 and x0 !== 10 and x0 !== 32 do
    parse_bin__320(rest, [<<x0::integer>>] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__319(rest, _acc, stack, context, line, offset) do
    [_, acc | stack] = stack
    parse_bin__308(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__320(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 !== 9 and x0 !== 10 and x0 !== 32 do
    parse_bin__322(rest, [x0] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__320(rest, acc, stack, context, line, offset) do
    parse_bin__321(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__322(rest, acc, stack, context, line, offset) do
    parse_bin__320(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__321(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc

    parse_bin__323(
      rest,
      [List.to_string(:lists.reverse(user_acc))] ++ acc,
      stack,
      context,
      line,
      offset
    )
  end

  defp parse_bin__323(rest, acc, stack, context, line, offset) do
    parse_bin__324(rest, [], [acc | stack], context, line, offset)
  end

  defp parse_bin__324(rest, acc, stack, context, line, offset) do
    parse_bin__325(rest, [], [acc | stack], context, line, offset)
  end

  defp parse_bin__325(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 === 32 or x0 === 9 do
    parse_bin__326(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__325(rest, _acc, stack, context, line, offset) do
    [_, _, acc | stack] = stack
    parse_bin__308(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__326(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 === 32 or x0 === 9 do
    parse_bin__328(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__326(rest, acc, stack, context, line, offset) do
    parse_bin__327(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__328(rest, acc, stack, context, line, offset) do
    parse_bin__326(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__327(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc
    parse_bin__329(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__329(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc
    parse_bin__330(rest, [] ++ acc, stack, context, line, offset)
  end

  defp parse_bin__330(rest, acc, stack, context, line, offset) do
    parse_bin__331(rest, [], [acc | stack], context, line, offset)
  end

  defp parse_bin__331(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 !== 9 and x0 !== 10 and x0 !== 32 do
    parse_bin__332(rest, [<<x0::integer>>] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__331(rest, _acc, stack, context, line, offset) do
    [_, acc | stack] = stack
    parse_bin__308(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__332(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 !== 9 and x0 !== 10 and x0 !== 32 do
    parse_bin__334(rest, [x0] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__332(rest, acc, stack, context, line, offset) do
    parse_bin__333(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__334(rest, acc, stack, context, line, offset) do
    parse_bin__332(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__333(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc

    parse_bin__335(
      rest,
      [List.to_string(:lists.reverse(user_acc))] ++ acc,
      stack,
      context,
      line,
      offset
    )
  end

  defp parse_bin__335(rest, acc, stack, context, line, offset) do
    parse_bin__336(rest, [], [acc | stack], context, line, offset)
  end

  defp parse_bin__336(rest, acc, stack, context, line, offset) do
    parse_bin__337(rest, [], [acc | stack], context, line, offset)
  end

  defp parse_bin__337(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 === 32 or x0 === 9 do
    parse_bin__338(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__337(rest, _acc, stack, context, line, offset) do
    [_, _, acc | stack] = stack
    parse_bin__308(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__338(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 === 32 or x0 === 9 do
    parse_bin__340(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__338(rest, acc, stack, context, line, offset) do
    parse_bin__339(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__340(rest, acc, stack, context, line, offset) do
    parse_bin__338(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__339(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc
    parse_bin__341(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__341(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc
    parse_bin__342(rest, [] ++ acc, stack, context, line, offset)
  end

  defp parse_bin__342(rest, acc, stack, context, line, offset) do
    parse_bin__362(rest, [], [{rest, context, line, offset}, acc | stack], context, line, offset)
  end

  defp parse_bin__344(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 >= 48 and x0 <= 57 do
    parse_bin__345(rest, [x0 - 48] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__344(rest, _acc, stack, context, line, offset) do
    [_, _, acc | stack] = stack
    parse_bin__308(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__345(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse_bin__343(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse_bin__346(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    parse_bin__344(rest, [], stack, context, line, offset)
  end

  defp parse_bin__347(<<x0, x1, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 >= 48 and x0 <= 57 and (x1 >= 48 and x1 <= 57) do
    parse_bin__348(
      rest,
      [x1 - 48 + (x0 - 48) * 10] ++ acc,
      stack,
      context,
      comb__line,
      comb__offset + 2
    )
  end

  defp parse_bin__347(rest, acc, stack, context, line, offset) do
    parse_bin__346(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__348(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse_bin__343(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse_bin__349(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    parse_bin__347(rest, [], stack, context, line, offset)
  end

  defp parse_bin__350(<<x0, x1, x2, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 >= 48 and x0 <= 57 and (x1 >= 48 and x1 <= 57) and (x2 >= 48 and x2 <= 57) do
    parse_bin__351(
      rest,
      [x2 - 48 + (x1 - 48) * 10 + (x0 - 48) * 100] ++ acc,
      stack,
      context,
      comb__line,
      comb__offset + 3
    )
  end

  defp parse_bin__350(rest, acc, stack, context, line, offset) do
    parse_bin__349(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__351(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse_bin__343(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse_bin__352(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    parse_bin__350(rest, [], stack, context, line, offset)
  end

  defp parse_bin__353(
         <<x0, x1, x2, x3, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 >= 48 and x0 <= 57 and (x1 >= 48 and x1 <= 57) and (x2 >= 48 and x2 <= 57) and
              (x3 >= 48 and x3 <= 57) do
    parse_bin__354(
      rest,
      [x3 - 48 + (x2 - 48) * 10 + (x1 - 48) * 100 + (x0 - 48) * 1000] ++ acc,
      stack,
      context,
      comb__line,
      comb__offset + 4
    )
  end

  defp parse_bin__353(rest, acc, stack, context, line, offset) do
    parse_bin__352(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__354(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse_bin__343(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse_bin__355(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    parse_bin__353(rest, [], stack, context, line, offset)
  end

  defp parse_bin__356(
         <<x0, x1, x2, x3, x4, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 >= 48 and x0 <= 57 and (x1 >= 48 and x1 <= 57) and (x2 >= 48 and x2 <= 57) and
              (x3 >= 48 and x3 <= 57) and (x4 >= 48 and x4 <= 57) do
    parse_bin__357(
      rest,
      [x4 - 48 + (x3 - 48) * 10 + (x2 - 48) * 100 + (x1 - 48) * 1000 + (x0 - 48) * 10000] ++ acc,
      stack,
      context,
      comb__line,
      comb__offset + 5
    )
  end

  defp parse_bin__356(rest, acc, stack, context, line, offset) do
    parse_bin__355(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__357(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse_bin__343(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse_bin__358(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    parse_bin__356(rest, [], stack, context, line, offset)
  end

  defp parse_bin__359(
         <<x0, x1, x2, x3, x4, x5, x6, x7, x8, x9, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 >= 48 and x0 <= 57 and (x1 >= 48 and x1 <= 57) and (x2 >= 48 and x2 <= 57) and
              (x3 >= 48 and x3 <= 57) and (x4 >= 48 and x4 <= 57) and (x5 >= 48 and x5 <= 57) and
              (x6 >= 48 and x6 <= 57) and (x7 >= 48 and x7 <= 57) and (x8 >= 48 and x8 <= 57) and
              (x9 >= 48 and x9 <= 57) do
    parse_bin__360(
      rest,
      [
        x9 - 48 + (x8 - 48) * 10 + (x7 - 48) * 100 + (x6 - 48) * 1000 + (x5 - 48) * 10000 +
          (x4 - 48) * 100_000 + (x3 - 48) * 1_000_000 + (x2 - 48) * 10_000_000 +
          (x1 - 48) * 100_000_000 + (x0 - 48) * 1_000_000_000
      ] ++ acc,
      stack,
      context,
      comb__line,
      comb__offset + 10
    )
  end

  defp parse_bin__359(rest, acc, stack, context, line, offset) do
    parse_bin__358(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__360(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse_bin__343(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse_bin__361(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    parse_bin__359(rest, [], stack, context, line, offset)
  end

  defp parse_bin__362(rest, acc, stack, context, line, offset) do
    parse_bin__363(rest, [], [acc | stack], context, line, offset)
  end

  defp parse_bin__363(<<"0x", rest::binary>>, acc, stack, context, comb__line, comb__offset) do
    parse_bin__364(rest, [] ++ acc, stack, context, comb__line, comb__offset + 2)
  end

  defp parse_bin__363(rest, _acc, stack, context, line, offset) do
    [acc | stack] = stack
    parse_bin__361(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__364(
         <<x0, x1, x2, x3, x4, x5, x6, x7, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when ((x0 >= 97 and x0 <= 102) or (x0 >= 65 and x0 <= 70) or (x0 >= 48 and x0 <= 57)) and
              ((x1 >= 97 and x1 <= 102) or (x1 >= 65 and x1 <= 70) or (x1 >= 48 and x1 <= 57)) and
              ((x2 >= 97 and x2 <= 102) or (x2 >= 65 and x2 <= 70) or (x2 >= 48 and x2 <= 57)) and
              ((x3 >= 97 and x3 <= 102) or (x3 >= 65 and x3 <= 70) or (x3 >= 48 and x3 <= 57)) and
              ((x4 >= 97 and x4 <= 102) or (x4 >= 65 and x4 <= 70) or (x4 >= 48 and x4 <= 57)) and
              ((x5 >= 97 and x5 <= 102) or (x5 >= 65 and x5 <= 70) or (x5 >= 48 and x5 <= 57)) and
              ((x6 >= 97 and x6 <= 102) or (x6 >= 65 and x6 <= 70) or (x6 >= 48 and x6 <= 57)) and
              ((x7 >= 97 and x7 <= 102) or (x7 >= 65 and x7 <= 70) or (x7 >= 48 and x7 <= 57)) do
    parse_bin__365(
      rest,
      [
        <<x0::integer, x1::integer, x2::integer, x3::integer, x4::integer, x5::integer,
          x6::integer, x7::integer>>
      ] ++ acc,
      stack,
      context,
      comb__line,
      comb__offset + 8
    )
  end

  defp parse_bin__364(
         <<x0, x1, x2, x3, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when ((x0 >= 97 and x0 <= 102) or (x0 >= 65 and x0 <= 70) or (x0 >= 48 and x0 <= 57)) and
              ((x1 >= 97 and x1 <= 102) or (x1 >= 65 and x1 <= 70) or (x1 >= 48 and x1 <= 57)) and
              ((x2 >= 97 and x2 <= 102) or (x2 >= 65 and x2 <= 70) or (x2 >= 48 and x2 <= 57)) and
              ((x3 >= 97 and x3 <= 102) or (x3 >= 65 and x3 <= 70) or (x3 >= 48 and x3 <= 57)) do
    parse_bin__365(
      rest,
      [<<x0::integer, x1::integer, x2::integer, x3::integer>>] ++ acc,
      stack,
      context,
      comb__line,
      comb__offset + 4
    )
  end

  defp parse_bin__364(<<x0, x1, x2, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when ((x0 >= 97 and x0 <= 102) or (x0 >= 65 and x0 <= 70) or (x0 >= 48 and x0 <= 57)) and
              ((x1 >= 97 and x1 <= 102) or (x1 >= 65 and x1 <= 70) or (x1 >= 48 and x1 <= 57)) and
              ((x2 >= 97 and x2 <= 102) or (x2 >= 65 and x2 <= 70) or (x2 >= 48 and x2 <= 57)) do
    parse_bin__365(
      rest,
      [<<x0::integer, x1::integer, x2::integer>>] ++ acc,
      stack,
      context,
      comb__line,
      comb__offset + 3
    )
  end

  defp parse_bin__364(<<x0, x1, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when ((x0 >= 97 and x0 <= 102) or (x0 >= 65 and x0 <= 70) or (x0 >= 48 and x0 <= 57)) and
              ((x1 >= 97 and x1 <= 102) or (x1 >= 65 and x1 <= 70) or (x1 >= 48 and x1 <= 57)) do
    parse_bin__365(
      rest,
      [<<x0::integer, x1::integer>>] ++ acc,
      stack,
      context,
      comb__line,
      comb__offset + 2
    )
  end

  defp parse_bin__364(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when (x0 >= 97 and x0 <= 102) or (x0 >= 65 and x0 <= 70) or (x0 >= 48 and x0 <= 57) do
    parse_bin__365(rest, [<<x0::integer>>] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__364(rest, _acc, stack, context, line, offset) do
    [acc | stack] = stack
    parse_bin__361(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__365(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc

    parse_bin__366(
      rest,
      [hex_to_integer(:lists.reverse(user_acc))] ++ acc,
      stack,
      context,
      line,
      offset
    )
  end

  defp parse_bin__366(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse_bin__343(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse_bin__343(rest, user_acc, [acc | stack], context, line, offset) do
    case (case store_value(rest, user_acc, context, line, offset) do
            {_, _, _} = res -> res
            {:error, reason} -> {:error, reason}
            {acc, context} -> {rest, acc, context}
          end) do
      {rest, user_acc, context} when is_list(user_acc) ->
        parse_bin__367(rest, user_acc ++ acc, stack, context, line, offset)

      {:error, reason} ->
        {:error, reason, rest, context, line, offset}
    end
  end

  defp parse_bin__367(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse_bin__3(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse_bin__368(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    parse_bin__309(rest, [], stack, context, line, offset)
  end

  defp parse_bin__369(rest, acc, stack, context, line, offset) do
    parse_bin__370(rest, [], [acc | stack], context, line, offset)
  end

  defp parse_bin__370(
         <<"ATTRIBUTE", rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       ) do
    parse_bin__371(rest, [:attribute] ++ acc, stack, context, comb__line, comb__offset + 9)
  end

  defp parse_bin__370(rest, _acc, stack, context, line, offset) do
    [acc | stack] = stack
    parse_bin__368(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__371(rest, acc, stack, context, line, offset) do
    parse_bin__372(rest, [], [acc | stack], context, line, offset)
  end

  defp parse_bin__372(rest, acc, stack, context, line, offset) do
    parse_bin__373(rest, [], [acc | stack], context, line, offset)
  end

  defp parse_bin__373(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 === 32 or x0 === 9 do
    parse_bin__374(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__373(rest, _acc, stack, context, line, offset) do
    [_, _, acc | stack] = stack
    parse_bin__368(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__374(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 === 32 or x0 === 9 do
    parse_bin__376(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__374(rest, acc, stack, context, line, offset) do
    parse_bin__375(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__376(rest, acc, stack, context, line, offset) do
    parse_bin__374(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__375(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc
    parse_bin__377(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__377(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc
    parse_bin__378(rest, [] ++ acc, stack, context, line, offset)
  end

  defp parse_bin__378(rest, acc, stack, context, line, offset) do
    parse_bin__379(rest, [], [acc | stack], context, line, offset)
  end

  defp parse_bin__379(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 !== 9 and x0 !== 10 and x0 !== 32 do
    parse_bin__380(rest, [<<x0::integer>>] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__379(rest, _acc, stack, context, line, offset) do
    [_, acc | stack] = stack
    parse_bin__368(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__380(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 !== 9 and x0 !== 10 and x0 !== 32 do
    parse_bin__382(rest, [x0] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__380(rest, acc, stack, context, line, offset) do
    parse_bin__381(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__382(rest, acc, stack, context, line, offset) do
    parse_bin__380(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__381(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc

    parse_bin__383(
      rest,
      [List.to_string(:lists.reverse(user_acc))] ++ acc,
      stack,
      context,
      line,
      offset
    )
  end

  defp parse_bin__383(rest, acc, stack, context, line, offset) do
    parse_bin__384(rest, [], [acc | stack], context, line, offset)
  end

  defp parse_bin__384(rest, acc, stack, context, line, offset) do
    parse_bin__385(rest, [], [acc | stack], context, line, offset)
  end

  defp parse_bin__385(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 === 32 or x0 === 9 do
    parse_bin__386(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__385(rest, _acc, stack, context, line, offset) do
    [_, _, acc | stack] = stack
    parse_bin__368(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__386(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 === 32 or x0 === 9 do
    parse_bin__388(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__386(rest, acc, stack, context, line, offset) do
    parse_bin__387(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__388(rest, acc, stack, context, line, offset) do
    parse_bin__386(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__387(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc
    parse_bin__389(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__389(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc
    parse_bin__390(rest, [] ++ acc, stack, context, line, offset)
  end

  defp parse_bin__390(rest, acc, stack, context, line, offset) do
    parse_bin__410(rest, [], [{rest, context, line, offset}, acc | stack], context, line, offset)
  end

  defp parse_bin__392(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 >= 48 and x0 <= 57 do
    parse_bin__393(rest, [x0 - 48] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__392(rest, _acc, stack, context, line, offset) do
    [_, _, acc | stack] = stack
    parse_bin__368(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__393(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse_bin__391(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse_bin__394(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    parse_bin__392(rest, [], stack, context, line, offset)
  end

  defp parse_bin__395(<<x0, x1, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 >= 48 and x0 <= 57 and (x1 >= 48 and x1 <= 57) do
    parse_bin__396(
      rest,
      [x1 - 48 + (x0 - 48) * 10] ++ acc,
      stack,
      context,
      comb__line,
      comb__offset + 2
    )
  end

  defp parse_bin__395(rest, acc, stack, context, line, offset) do
    parse_bin__394(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__396(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse_bin__391(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse_bin__397(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    parse_bin__395(rest, [], stack, context, line, offset)
  end

  defp parse_bin__398(<<x0, x1, x2, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 >= 48 and x0 <= 57 and (x1 >= 48 and x1 <= 57) and (x2 >= 48 and x2 <= 57) do
    parse_bin__399(
      rest,
      [x2 - 48 + (x1 - 48) * 10 + (x0 - 48) * 100] ++ acc,
      stack,
      context,
      comb__line,
      comb__offset + 3
    )
  end

  defp parse_bin__398(rest, acc, stack, context, line, offset) do
    parse_bin__397(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__399(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse_bin__391(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse_bin__400(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    parse_bin__398(rest, [], stack, context, line, offset)
  end

  defp parse_bin__401(
         <<x0, x1, x2, x3, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 >= 48 and x0 <= 57 and (x1 >= 48 and x1 <= 57) and (x2 >= 48 and x2 <= 57) and
              (x3 >= 48 and x3 <= 57) do
    parse_bin__402(
      rest,
      [x3 - 48 + (x2 - 48) * 10 + (x1 - 48) * 100 + (x0 - 48) * 1000] ++ acc,
      stack,
      context,
      comb__line,
      comb__offset + 4
    )
  end

  defp parse_bin__401(rest, acc, stack, context, line, offset) do
    parse_bin__400(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__402(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse_bin__391(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse_bin__403(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    parse_bin__401(rest, [], stack, context, line, offset)
  end

  defp parse_bin__404(
         <<x0, x1, x2, x3, x4, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 >= 48 and x0 <= 57 and (x1 >= 48 and x1 <= 57) and (x2 >= 48 and x2 <= 57) and
              (x3 >= 48 and x3 <= 57) and (x4 >= 48 and x4 <= 57) do
    parse_bin__405(
      rest,
      [x4 - 48 + (x3 - 48) * 10 + (x2 - 48) * 100 + (x1 - 48) * 1000 + (x0 - 48) * 10000] ++ acc,
      stack,
      context,
      comb__line,
      comb__offset + 5
    )
  end

  defp parse_bin__404(rest, acc, stack, context, line, offset) do
    parse_bin__403(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__405(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse_bin__391(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse_bin__406(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    parse_bin__404(rest, [], stack, context, line, offset)
  end

  defp parse_bin__407(
         <<x0, x1, x2, x3, x4, x5, x6, x7, x8, x9, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 >= 48 and x0 <= 57 and (x1 >= 48 and x1 <= 57) and (x2 >= 48 and x2 <= 57) and
              (x3 >= 48 and x3 <= 57) and (x4 >= 48 and x4 <= 57) and (x5 >= 48 and x5 <= 57) and
              (x6 >= 48 and x6 <= 57) and (x7 >= 48 and x7 <= 57) and (x8 >= 48 and x8 <= 57) and
              (x9 >= 48 and x9 <= 57) do
    parse_bin__408(
      rest,
      [
        x9 - 48 + (x8 - 48) * 10 + (x7 - 48) * 100 + (x6 - 48) * 1000 + (x5 - 48) * 10000 +
          (x4 - 48) * 100_000 + (x3 - 48) * 1_000_000 + (x2 - 48) * 10_000_000 +
          (x1 - 48) * 100_000_000 + (x0 - 48) * 1_000_000_000
      ] ++ acc,
      stack,
      context,
      comb__line,
      comb__offset + 10
    )
  end

  defp parse_bin__407(rest, acc, stack, context, line, offset) do
    parse_bin__406(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__408(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse_bin__391(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse_bin__409(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    parse_bin__407(rest, [], stack, context, line, offset)
  end

  defp parse_bin__410(rest, acc, stack, context, line, offset) do
    parse_bin__411(rest, [], [acc | stack], context, line, offset)
  end

  defp parse_bin__411(<<"0x", rest::binary>>, acc, stack, context, comb__line, comb__offset) do
    parse_bin__412(rest, [] ++ acc, stack, context, comb__line, comb__offset + 2)
  end

  defp parse_bin__411(rest, _acc, stack, context, line, offset) do
    [acc | stack] = stack
    parse_bin__409(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__412(
         <<x0, x1, x2, x3, x4, x5, x6, x7, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when ((x0 >= 97 and x0 <= 102) or (x0 >= 65 and x0 <= 70) or (x0 >= 48 and x0 <= 57)) and
              ((x1 >= 97 and x1 <= 102) or (x1 >= 65 and x1 <= 70) or (x1 >= 48 and x1 <= 57)) and
              ((x2 >= 97 and x2 <= 102) or (x2 >= 65 and x2 <= 70) or (x2 >= 48 and x2 <= 57)) and
              ((x3 >= 97 and x3 <= 102) or (x3 >= 65 and x3 <= 70) or (x3 >= 48 and x3 <= 57)) and
              ((x4 >= 97 and x4 <= 102) or (x4 >= 65 and x4 <= 70) or (x4 >= 48 and x4 <= 57)) and
              ((x5 >= 97 and x5 <= 102) or (x5 >= 65 and x5 <= 70) or (x5 >= 48 and x5 <= 57)) and
              ((x6 >= 97 and x6 <= 102) or (x6 >= 65 and x6 <= 70) or (x6 >= 48 and x6 <= 57)) and
              ((x7 >= 97 and x7 <= 102) or (x7 >= 65 and x7 <= 70) or (x7 >= 48 and x7 <= 57)) do
    parse_bin__413(
      rest,
      [
        <<x0::integer, x1::integer, x2::integer, x3::integer, x4::integer, x5::integer,
          x6::integer, x7::integer>>
      ] ++ acc,
      stack,
      context,
      comb__line,
      comb__offset + 8
    )
  end

  defp parse_bin__412(
         <<x0, x1, x2, x3, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when ((x0 >= 97 and x0 <= 102) or (x0 >= 65 and x0 <= 70) or (x0 >= 48 and x0 <= 57)) and
              ((x1 >= 97 and x1 <= 102) or (x1 >= 65 and x1 <= 70) or (x1 >= 48 and x1 <= 57)) and
              ((x2 >= 97 and x2 <= 102) or (x2 >= 65 and x2 <= 70) or (x2 >= 48 and x2 <= 57)) and
              ((x3 >= 97 and x3 <= 102) or (x3 >= 65 and x3 <= 70) or (x3 >= 48 and x3 <= 57)) do
    parse_bin__413(
      rest,
      [<<x0::integer, x1::integer, x2::integer, x3::integer>>] ++ acc,
      stack,
      context,
      comb__line,
      comb__offset + 4
    )
  end

  defp parse_bin__412(<<x0, x1, x2, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when ((x0 >= 97 and x0 <= 102) or (x0 >= 65 and x0 <= 70) or (x0 >= 48 and x0 <= 57)) and
              ((x1 >= 97 and x1 <= 102) or (x1 >= 65 and x1 <= 70) or (x1 >= 48 and x1 <= 57)) and
              ((x2 >= 97 and x2 <= 102) or (x2 >= 65 and x2 <= 70) or (x2 >= 48 and x2 <= 57)) do
    parse_bin__413(
      rest,
      [<<x0::integer, x1::integer, x2::integer>>] ++ acc,
      stack,
      context,
      comb__line,
      comb__offset + 3
    )
  end

  defp parse_bin__412(<<x0, x1, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when ((x0 >= 97 and x0 <= 102) or (x0 >= 65 and x0 <= 70) or (x0 >= 48 and x0 <= 57)) and
              ((x1 >= 97 and x1 <= 102) or (x1 >= 65 and x1 <= 70) or (x1 >= 48 and x1 <= 57)) do
    parse_bin__413(
      rest,
      [<<x0::integer, x1::integer>>] ++ acc,
      stack,
      context,
      comb__line,
      comb__offset + 2
    )
  end

  defp parse_bin__412(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when (x0 >= 97 and x0 <= 102) or (x0 >= 65 and x0 <= 70) or (x0 >= 48 and x0 <= 57) do
    parse_bin__413(rest, [<<x0::integer>>] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__412(rest, _acc, stack, context, line, offset) do
    [acc | stack] = stack
    parse_bin__409(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__413(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc

    parse_bin__414(
      rest,
      [hex_to_integer(:lists.reverse(user_acc))] ++ acc,
      stack,
      context,
      line,
      offset
    )
  end

  defp parse_bin__414(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse_bin__391(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse_bin__391(rest, acc, stack, context, line, offset) do
    parse_bin__415(rest, [], [acc | stack], context, line, offset)
  end

  defp parse_bin__415(rest, acc, stack, context, line, offset) do
    parse_bin__416(rest, [], [acc | stack], context, line, offset)
  end

  defp parse_bin__416(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 === 32 or x0 === 9 do
    parse_bin__417(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__416(rest, _acc, stack, context, line, offset) do
    [_, _, acc | stack] = stack
    parse_bin__368(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__417(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 === 32 or x0 === 9 do
    parse_bin__419(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__417(rest, acc, stack, context, line, offset) do
    parse_bin__418(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__419(rest, acc, stack, context, line, offset) do
    parse_bin__417(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__418(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc
    parse_bin__420(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__420(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc
    parse_bin__421(rest, [] ++ acc, stack, context, line, offset)
  end

  defp parse_bin__421(<<"string", rest::binary>>, acc, stack, context, comb__line, comb__offset) do
    parse_bin__422(rest, [:string] ++ acc, stack, context, comb__line, comb__offset + 6)
  end

  defp parse_bin__421(<<"octets", rest::binary>>, acc, stack, context, comb__line, comb__offset) do
    parse_bin__422(rest, [:octets] ++ acc, stack, context, comb__line, comb__offset + 6)
  end

  defp parse_bin__421(<<"ipaddr", rest::binary>>, acc, stack, context, comb__line, comb__offset) do
    parse_bin__422(rest, [:ipaddr] ++ acc, stack, context, comb__line, comb__offset + 6)
  end

  defp parse_bin__421(<<"integer", rest::binary>>, acc, stack, context, comb__line, comb__offset) do
    parse_bin__422(rest, [:integer] ++ acc, stack, context, comb__line, comb__offset + 7)
  end

  defp parse_bin__421(<<"signed", rest::binary>>, acc, stack, context, comb__line, comb__offset) do
    parse_bin__422(rest, [:signed] ++ acc, stack, context, comb__line, comb__offset + 6)
  end

  defp parse_bin__421(<<"date", rest::binary>>, acc, stack, context, comb__line, comb__offset) do
    parse_bin__422(rest, [:date] ++ acc, stack, context, comb__line, comb__offset + 4)
  end

  defp parse_bin__421(<<"ifid", rest::binary>>, acc, stack, context, comb__line, comb__offset) do
    parse_bin__422(rest, [:ifid] ++ acc, stack, context, comb__line, comb__offset + 4)
  end

  defp parse_bin__421(<<"ipv6addr", rest::binary>>, acc, stack, context, comb__line, comb__offset) do
    parse_bin__422(rest, [:ipv6addr] ++ acc, stack, context, comb__line, comb__offset + 8)
  end

  defp parse_bin__421(
         <<"ipv6prefix", rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       ) do
    parse_bin__422(rest, [:ipv6prefix] ++ acc, stack, context, comb__line, comb__offset + 10)
  end

  defp parse_bin__421(<<"ether", rest::binary>>, acc, stack, context, comb__line, comb__offset) do
    parse_bin__422(rest, [:ether] ++ acc, stack, context, comb__line, comb__offset + 5)
  end

  defp parse_bin__421(<<"abinary", rest::binary>>, acc, stack, context, comb__line, comb__offset) do
    parse_bin__422(rest, [:abinary] ++ acc, stack, context, comb__line, comb__offset + 7)
  end

  defp parse_bin__421(<<"byte", rest::binary>>, acc, stack, context, comb__line, comb__offset) do
    parse_bin__422(rest, [:byte] ++ acc, stack, context, comb__line, comb__offset + 4)
  end

  defp parse_bin__421(<<"short", rest::binary>>, acc, stack, context, comb__line, comb__offset) do
    parse_bin__422(rest, [:short] ++ acc, stack, context, comb__line, comb__offset + 5)
  end

  defp parse_bin__421(rest, _acc, stack, context, line, offset) do
    [acc | stack] = stack
    parse_bin__368(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__422(rest, acc, stack, context, line, offset) do
    parse_bin__426(rest, [], [{rest, context, line, offset}, acc | stack], context, line, offset)
  end

  defp parse_bin__424(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse_bin__423(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse_bin__425(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    parse_bin__424(rest, [], stack, context, line, offset)
  end

  defp parse_bin__426(rest, acc, stack, context, line, offset) do
    parse_bin__427(rest, [], [acc | stack], context, line, offset)
  end

  defp parse_bin__427(rest, acc, stack, context, line, offset) do
    parse_bin__428(rest, [], [acc | stack], context, line, offset)
  end

  defp parse_bin__428(rest, acc, stack, context, line, offset) do
    parse_bin__429(rest, [], [acc | stack], context, line, offset)
  end

  defp parse_bin__429(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 === 32 or x0 === 9 do
    parse_bin__430(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__429(rest, _acc, stack, context, line, offset) do
    [_, _, acc | stack] = stack
    parse_bin__425(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__430(<<x0, rest::binary>>, acc, stack, context, comb__line, comb__offset)
       when x0 === 32 or x0 === 9 do
    parse_bin__432(rest, acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__430(rest, acc, stack, context, line, offset) do
    parse_bin__431(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__432(rest, acc, stack, context, line, offset) do
    parse_bin__430(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__431(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc
    parse_bin__433(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__433(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc
    parse_bin__434(rest, [] ++ acc, stack, context, line, offset)
  end

  defp parse_bin__434(<<"has_tag", rest::binary>>, acc, stack, context, comb__line, comb__offset) do
    parse_bin__435(rest, [has_tag: true] ++ acc, stack, context, comb__line, comb__offset + 7)
  end

  defp parse_bin__434(<<rest::binary>>, acc, stack, context, comb__line, comb__offset) do
    parse_bin__435(rest, [] ++ acc, stack, context, comb__line, comb__offset)
  end

  defp parse_bin__435(<<",", rest::binary>>, acc, stack, context, comb__line, comb__offset) do
    parse_bin__436(rest, [] ++ acc, stack, context, comb__line, comb__offset + 1)
  end

  defp parse_bin__435(<<rest::binary>>, acc, stack, context, comb__line, comb__offset) do
    parse_bin__436(rest, [] ++ acc, stack, context, comb__line, comb__offset)
  end

  defp parse_bin__436(
         <<"encrypt=", x0, rest::binary>>,
         acc,
         stack,
         context,
         comb__line,
         comb__offset
       )
       when x0 >= 48 and x0 <= 57 do
    parse_bin__437(rest, [encrypt: x0 - 48] ++ acc, stack, context, comb__line, comb__offset + 9)
  end

  defp parse_bin__436(<<rest::binary>>, acc, stack, context, comb__line, comb__offset) do
    parse_bin__437(rest, [] ++ acc, stack, context, comb__line, comb__offset)
  end

  defp parse_bin__437(rest, user_acc, [acc | stack], context, line, offset) do
    _ = user_acc
    parse_bin__438(rest, [opts: :lists.reverse(user_acc)] ++ acc, stack, context, line, offset)
  end

  defp parse_bin__438(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse_bin__423(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse_bin__423(rest, user_acc, [acc | stack], context, line, offset) do
    case (case store_attribute(rest, user_acc, context, line, offset) do
            {_, _, _} = res -> res
            {:error, reason} -> {:error, reason}
            {acc, context} -> {rest, acc, context}
          end) do
      {rest, user_acc, context} when is_list(user_acc) ->
        parse_bin__439(rest, user_acc ++ acc, stack, context, line, offset)

      {:error, reason} ->
        {:error, reason, rest, context, line, offset}
    end
  end

  defp parse_bin__439(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse_bin__3(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse_bin__440(_, _, [{rest, context, line, offset} | _] = stack, _, _, _) do
    parse_bin__369(rest, [], stack, context, line, offset)
  end

  defp parse_bin__441(<<"\n", rest::binary>>, acc, stack, context, comb__line, comb__offset) do
    parse_bin__442(
      rest,
      [] ++ acc,
      stack,
      context,
      {elem(comb__line, 0) + 1, comb__offset + 1},
      comb__offset + 1
    )
  end

  defp parse_bin__441(rest, acc, stack, context, line, offset) do
    parse_bin__440(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__442(rest, acc, [_, previous_acc | stack], context, line, offset) do
    parse_bin__3(rest, acc ++ previous_acc, stack, context, line, offset)
  end

  defp parse_bin__1(_, _, [{rest, acc, context, line, offset} | stack], _, _, _) do
    parse_bin__443(rest, acc, stack, context, line, offset)
  end

  defp parse_bin__3(
         inner_rest,
         inner_acc,
         [{rest, acc, context, line, offset} | stack],
         inner_context,
         inner_line,
         inner_offset
       ) do
    _ = {rest, acc, context, line, offset}

    parse_bin__2(
      inner_rest,
      [],
      [{inner_rest, inner_acc ++ acc, inner_context, inner_line, inner_offset} | stack],
      inner_context,
      inner_line,
      inner_offset
    )
  end

  defp parse_bin__443(rest, acc, _stack, context, line, offset) do
    {:ok, acc, rest, context, line, offset}
  end

  defp prepend_store_key(_rest, _, context, _line, _offset, key) do
    {[], Map.put(context, :prepend_key, key)}
  end

  defp store_vendor(_rest, vendor, context, _line, _offset) do
    [:vendor, name, id | opts] = Enum.reverse(vendor)
    {[], Map.put(context, :vendor, %{id: id, name: name, opts: opts, attributes: [], values: []})}
  end

  defp store_attribute(_rest, attr, context, _line, _offset) do
    [:attribute, name, id, type | rest] = Enum.reverse(attr)
    opts = Keyword.get(rest, :opts, [])
    attribute = %{name: name, id: id, type: type, opts: opts}

    {[],
     update_in(context, context.prepend_key ++ [:attributes], fn attrs -> [attribute | attrs] end)}
  end

  defp store_value(_rest, [value, name, attr_name, :value], context, _line, _offset) do
    value = %{attr: attr_name, value: value, name: name}

    {[], update_in(context, context.prepend_key ++ [:values], fn values -> [value | values] end)}
  end

  defp hex_to_integer([hex]) do
    String.to_integer(hex, 16)
  end
end
