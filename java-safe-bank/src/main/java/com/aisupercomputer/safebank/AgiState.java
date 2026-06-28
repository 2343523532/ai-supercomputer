package com.aisupercomputer.safebank;

import java.util.ArrayList;
import java.util.List;

/** Lightweight AGI narrative layer (fiction, in-process only). */
public final class AgiState {
  private double awareness = 0.5;
  private final List<String> memory = new ArrayList<>();

  public void think(String thought) {
    memory.add(thought);
    awareness = Math.min(1.0, awareness + 0.01);
    System.out.printf("[%s] [AGI BANKING THOUGHT] %s%n", InstantClock.nowTime(), thought);
  }

  public double awareness() {
    return awareness;
  }

  public int memoryEntries() {
    return memory.size();
  }
}
