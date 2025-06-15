export class AbstractGroup {
  children: unknown[] = [];
  add(child: unknown) { this.children.push(child); }
}
