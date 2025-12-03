# Test Audit Rules

Detailed rules for test suite quality audit.

## 1. Business Logic Focus

### What to Test (OUR Code)

| Test This | Why |
|-----------|-----|
| Tax calculation with country rules | OUR algorithm |
| Discount logic with business rules | OUR logic |
| Permission matrix decisions | OUR security rules |
| Custom validation rules | OUR requirements |
| Data transformation logic | OUR business mapping |

### What NOT to Test (Framework/Library)

| Don't Test | Why | Trust |
|------------|-----|-------|
| bcrypt.hash() / bcrypt.compare() | Library behavior | bcrypt has tests |
| jwt.sign() / jwt.verify() | Library behavior | jsonwebtoken has tests |
| prisma.user.findUnique() | ORM behavior | Prisma has tests |
| express.Router() | Framework behavior | Express has tests |
| axios.get() / axios.post() | Library behavior | Axios has tests |
| useState() / useEffect() | Framework behavior | React has tests |

### Detection Patterns

```regex
# Framework tests (flag for removal)
(prisma|mongoose|sequelize|typeorm)\.(find|create|update|delete)
(express|fastify|koa)\.(use|get|post|put|delete)
(bcrypt|argon2)\.(hash|compare|verify)
(jwt|jsonwebtoken)\.(sign|verify|decode)
(axios|fetch|got)\.(get|post|put|delete)
(useState|useEffect|useContext|useReducer)
```

---

## 2. E2E Priority

### Test Pyramid (Risk-Based)

| Type | Target | Purpose |
|------|--------|---------|
| **E2E** | 2 per endpoint | Prove feature works end-to-end |
| **Integration** | 0-8 per Story | Complex interactions not covered by E2E |
| **Unit** | 0-15 per Story | Complex algorithms with many edge cases |

### E2E Baseline (MANDATORY)

Every endpoint MUST have:
1. **Positive E2E:** Happy path validates main AC
2. **Negative E2E:** Critical error handling

### When Unit/Integration Are Justified

| Add Unit/Integration When | Example |
|---------------------------|---------|
| E2E doesn't exercise all algorithm branches | Tax calc with 10 country rules |
| E2E is too slow for edge case testing | Currency conversion edge cases |
| Complex error scenarios | Transaction rollback on partial failure |
| Concurrency testing | Race condition in shared state |

---

## 3. Risk-Based Value

### Usefulness Score Formula

```
Score = Impact (1-5) × Probability (1-5)
```

### Decision Thresholds

| Score | Decision | Action |
|-------|----------|--------|
| **15-25** | KEEP | High value, maintain |
| **10-14** | REVIEW | Check if E2E covers |
| **1-9** | REMOVE | Delete, not worth cost |

### Impact Examples

| Impact 5 (Critical) | Impact 1 (Trivial) |
|---------------------|-------------------|
| Payment calculation | Button color |
| Authentication | Tooltip text |
| Data encryption | Spacing |
| Order processing | Icon size |

### Probability Examples

| Probability 5 (Very High) | Probability 1 (Very Low) |
|---------------------------|-------------------------|
| New algorithm | Getter/setter |
| External API | Constant return |
| Complex state | Framework-generated |
| Concurrency | Simple assignment |

---

## 4. Coverage Gaps

### Critical Paths (MUST Test)

| Category | Examples | Min Priority |
|----------|----------|--------------|
| **Money** | Payments, discounts, taxes, refunds | 20+ |
| **Security** | Auth, permissions, encryption | 20+ |
| **Data Integrity** | CRUD, transactions, validation | 15+ |
| **Core Flows** | Checkout, registration, search | 15+ |

### Gap Detection Questions

1. **Money flows tested?** Payment, discount, tax, refund
2. **Auth flows tested?** Login, logout, token refresh, permissions
3. **Critical user journeys tested?** Registration → Purchase → Delivery
4. **Error scenarios tested?** API failure, timeout, invalid data

---

## 5. Test Isolation

### Isolation Checklist

| Check | Good | Bad |
|-------|------|-----|
| External APIs | Mocked | Real calls |
| Database | In-memory/mocked | Real DB |
| File system | Mocked | Real files |
| Time/Date | Mocked | new Date() |
| Random | Seeded | Math.random() |
| Network | Mocked | Real requests |

### Isolation Red Flags

```javascript
// BAD: Real external dependency
test('sends email', async () => {
  await sendEmail('user@example.com'); // Real SMTP call!
});

// GOOD: Mocked dependency
test('sends email', async () => {
  const mockSend = jest.fn();
  await sendEmail('user@example.com', { send: mockSend });
  expect(mockSend).toHaveBeenCalled();
});
```

### Determinism Checklist

- [ ] No flaky tests (pass/fail randomly)
- [ ] No time-dependent assertions
- [ ] No order-dependent tests
- [ ] No shared mutable state between tests
- [ ] No real network/DB/filesystem calls

---

## 6. Anti-Patterns Catalog

### The Liar (Evergreen Test)

**Problem:** Test always passes, validates nothing.

```javascript
// BAD: No real assertion
test('user is created', async () => {
  const user = await createUser(data);
  expect(user).toBeTruthy(); // Always true if no throw
});

// GOOD: Specific assertion
test('user is created with correct email', async () => {
  const user = await createUser({ email: 'test@example.com' });
  expect(user.email).toBe('test@example.com');
});
```

### The Giant (>100 Lines)

**Problem:** Too many scenarios in one test, hard to maintain.

**Fix:** Split into focused tests, one scenario each.

### Slow Poke (>5 Seconds)

**Problem:** Test too slow, developers skip running it.

**Fix:** Mock external calls, use in-memory DB, parallelize.

### Conjoined Twins

**Problem:** Unit test with no isolation = actually integration test.

**Fix:** Mock dependencies or rename to integration test.

### Happy Path Only

**Problem:** Only tests success scenario, ignores errors.

**Fix:** Add negative test for each positive test.

### Framework Tester

**Problem:** Tests framework behavior, not OUR code.

```javascript
// BAD: Testing Express
test('middleware is called', () => { ... });

// BAD: Testing Prisma
test('findMany returns array', () => { ... });

// GOOD: Testing OUR business logic
test('discount applied for bulk orders', () => { ... });
```

### The Dodger

**Problem:** Tests trivial side effects, avoids core logic.

**Fix:** Identify core behavior, write test for it.

---

## Quick Audit Commands

```bash
# Find test files
find . -name "*.test.*" -o -name "*.spec.*" | head -50

# Count tests by type
grep -r "describe\|it\|test" --include="*.test.*" | wc -l

# Find framework tests (candidates for removal)
grep -rn "prisma\.\|bcrypt\.\|jwt\.\|axios\." --include="*.test.*"

# Find tests without assertions
grep -rn "expect(" --include="*.test.*" -L

# Find slow tests (timeout hints)
grep -rn "timeout\|jest.setTimeout" --include="*.test.*"

# Find flaky indicators
grep -rn "retry\|flaky\|skip\|xit\|xdescribe" --include="*.test.*"

# Count E2E vs Unit
find . -path "*e2e*" -name "*.test.*" | wc -l
find . -path "*unit*" -name "*.test.*" | wc -l
```

---

## Test Justification Template

For each test beyond 2 baseline E2E, document:

```markdown
### Test: [Test Name]
- **File:** path/to/test.ts:line
- **Type:** E2E / Integration / Unit
- **Impact:** X/5 - [reason]
- **Probability:** X/5 - [reason]
- **Usefulness Score:** X (Impact × Probability)
- **Decision:** KEEP / REVIEW / REMOVE
- **Justification:** Why this test matters for OUR business logic
```
