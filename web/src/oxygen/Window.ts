import React from 'react';

export class Window {
  constructor(
    public id: string,
    public title: string,
    public content: React.ReactNode
  ) {}
}
