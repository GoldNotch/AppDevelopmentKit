// Copyright 2023 JohnCorn
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
#include <cmath>
#include <cstdio>
#include <thread>

#include "App.h"

#define LOGGING_IMPLEMENTATION
#include <Logging.hpp>
IMPLEMENT_LOGGING_API(App, USAPP_API)

#include "Game.hpp"

static std::unique_ptr<Game> st_game;

USAPP_API void usApp_Init()
{
  //io::Log(usLogStatus::US_LOG_INFO, 0, "initialize App");
  st_game = std::make_unique<Game>();
}

USAPP_API void usApp_Tick()
{
  st_game->Tick();
}

USAPP_API void usApp_Terminate()
{
  st_game.reset();
  std::printf("terminate\n");
}


USAPP_API void usApp_InitRenderableScene(const RenderSceneHandler scene)
{
  //std::printf("collect frame data\n");
  st_game->InitRenderableScene(scene);
}
