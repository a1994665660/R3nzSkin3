#!/bin/bash
set -e

cd /workspace/R3nzSkin

CXX=x86_64-w64-mingw32-g++
CXXFLAGS="-std=c++23 -O2 -DNDEBUG -DWIN32 -DR3NZSKIN_EXPORTS -D_WINDOWS -D_USRDLL -D_CRT_SECURE_NO_WARNINGS -D__SSE2__ -msse2 -I. -include mingw_compat.hpp -Wno-attributes -fpermissive"
LDFLAGS="-shared -static -static-libgcc -static-libstdc++ -Wl,--out-implib,libR3nzSkin.a"
LIBS="-ld3d11 -ldxgi -ld3dcompiler -ldwmapi -lcomdlg32 -lshlwapi -luser32 -lgdi32 -ladvapi32 -lkernel32 -lole32 -lshell32 -limm32 -luuid"

SOURCES=(
  "Config.cpp"
  "Hooks.cpp"
  "Memory.cpp"
  "R3nzSkin.cpp"
  "GUI.cpp"
  "SkinDatabase.cpp"
  "Utils.cpp"
  "SDK/AIBaseCommon.cpp"
  "SDK/AIMinionClient.cpp"
  "SDK/CharacterDataStack.cpp"
  "imgui/imgui.cpp"
  "imgui/imgui_demo.cpp"
  "imgui/imgui_draw.cpp"
  "imgui/imgui_impl_dx11.cpp"
  "imgui/imgui_impl_win32.cpp"
  "imgui/imgui_tables.cpp"
  "imgui/imgui_widgets.cpp"
)

OBJDIR=/tmp/r3nzskin_obj
mkdir -p "$OBJDIR"

echo "=== Compiling sources ==="
for src in "${SOURCES[@]}"; do
  obj="$OBJDIR/$(echo "$src" | tr '/' '_').o"
  echo "  CC $src"
  $CXX $CXXFLAGS -c "$src" -o "$obj"
done

echo ""
echo "=== Linking R3nzSkin.dll ==="
OBJS=$(ls "$OBJDIR"/*.o)
$CXX $LDFLAGS $OBJS -o /workspace/Release/ChinaServer/x64/R3nzSkin.dll $LIBS

echo ""
echo "=== Done ==="
ls -la /workspace/Release/ChinaServer/x64/R3nzSkin.dll
